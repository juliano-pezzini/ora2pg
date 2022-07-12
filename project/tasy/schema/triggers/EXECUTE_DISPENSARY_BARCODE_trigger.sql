-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS execute_dispensary_barcode ON item_requisicao_material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_execute_dispensary_barcode() RETURNS trigger AS $BODY$
DECLARE
    --PRAGMA autonomous_transaction;
    SUBTYPE one_char IS varchar(1);
    SUBTYPE two_char IS varchar(2);
    SUBTYPE seven_char IS varchar(7);
    SUBTYPE nine_char IS varchar(9);
    SUBTYPE eleven_char IS varchar(11);
    SUBTYPE twelve_char IS varchar(12);
    SUBTYPE thirteen_char IS varchar(13);
    SUBTYPE fourteen_char IS varchar(14);
    SUBTYPE fifteen_char IS varchar(15);
    SUBTYPE sixteen_char IS varchar(16);
    SUBTYPE seventeen_char IS varchar(17);
    SUBTYPE eighteen_char IS varchar(18);
    SUBTYPE twenty_two_char IS varchar(22);
    SUBTYPE twenty_char IS varchar(20);
    SUBTYPE fourty_char IS varchar(40);
    SUBTYPE fourty_tree_char IS varchar(45);
    SUBTYPE four_thousand_char IS varchar(4000);
    cd_local_estoque_w           local_estoque.cd_local_estoque%TYPE;
    contador_w                   integer;
    ds_material_w                material.ds_material%TYPE;
    ie_forma_integracao_w        dis_parametros_int.ie_forma_integracao%TYPE;
    ie_tipo_local_w              local_estoque.ie_tipo_local%TYPE;
    product_type_id_w            material.ie_tipo_material%TYPE;
    json_w                       four_thousand_char;
    char_eleven_c                CONSTANT two_char := '11';
    char_s_c                     CONSTANT one_char := 'S';
    error_code_generic_c CONSTANT integer := -20909;
    error_message_generic_c      CONSTANT fourty_tree_char := 'Error executing execute_dispensary_barcode.';
    forma_integracao_b_c         CONSTANT dis_parametros_int.ie_forma_integracao%TYPE := 'B';
    forma_integracao_m_c         CONSTANT dis_parametros_int.ie_forma_integracao%TYPE := 'M';
    json_closed_brace_c          CONSTANT one_char := '}';
    json_closed_bracket_c        CONSTANT one_char := ']';
    json_comma_c                 CONSTANT one_char := ',';
    json_barcodes                CONSTANT eleven_char := '"barcodes":';
    json_batch_number            CONSTANT fourteen_char := '"batchNumber":';
    json_code_fornec             CONSTANT thirteen_char := '"codeFornec":';
    json_customer_code           CONSTANT fifteen_char := '"customerCode":';
    json_stock_code              CONSTANT twelve_char := '"stockCode":';
    json_expiration_date         CONSTANT seventeen_char := '"expirationDate":';
    json_open_brace_c            CONSTANT one_char := '{';
    json_open_bracket_c          CONSTANT one_char := '[';
    json_quotation_mark_c        CONSTANT one_char := '"';
    json_name                    CONSTANT seven_char := '"name":';
    json_number                  CONSTANT nine_char := '"number":';
    json_product_type_id         CONSTANT sixteen_char := '"productTypeId":';
    json_number_requisition      CONSTANT twenty_char := '"numberRequisition":';
    nr_integration_code_c        CONSTANT integer := 1155;
    nr_zero_c                     CONSTANT integer := 0;
    nr_one_c                     CONSTANT integer := 1;
    nr_two_c                     CONSTANT integer := 2;
    nr_ten_c                     CONSTANT integer := 10;
    barcodes_cursor CURSOR FOR
    SELECT
    DISTINCT
        mlf.nr_sequencia,
        mlf.cd_cgc_fornec AS codeFornec,
        mlf.ds_barras AS batchNumber,
        mlf.ds_lote_fornec AS numberLote,
        to_char(mlf.dt_validade,'YYYY-MM-DD') AS expirationDate
    FROM
        material_lote_fornec mlf
    WHERE
        mlf.cd_material = NEW.cd_material
    and
        mlf.nr_sequencia = NEW.NR_SEQ_LOTE_FORNEC;
BEGIN
  BEGIN
    IF ( wheb_usuario_pck.get_ie_executar_trigger = char_s_c ) THEN

    IF (NEW.cd_pessoa_atende is not null and NEW.NR_SEQ_LOTE_FORNEC is not null) then
        << get_ie_forma_integracao >> BEGIN
            SELECT
                COUNT(ie_forma_integracao)
            INTO STRICT ie_forma_integracao_w
            FROM
                dis_parametros_int
            WHERE
                ie_forma_integracao IN (
                    forma_integracao_m_c,
                    forma_integracao_b_c
                );
        EXCEPTION
            WHEN no_data_found THEN
                RAISE EXCEPTION '%', error_message_generic_c USING ERRCODE = error_code_generic_c;
            WHEN too_many_rows THEN
                RAISE EXCEPTION '%', error_message_generic_c USING ERRCODE = error_code_generic_c;
        END;

        IF ( ie_forma_integracao_w > nr_zero_c) THEN
            << get_ie_tipo_local >> BEGIN
                SELECT	max(le.ie_tipo_local),
						max(le.cd_local_estoque)
                INTO STRICT	ie_tipo_local_w,
						cd_local_estoque_w
                FROM	requisicao_material	re
						JOIN local_estoque	le
						ON le.cd_local_estoque = re.cd_local_estoque_destino
				WHERE	re.nr_requisicao = NEW.nr_requisicao;

            EXCEPTION
                WHEN no_data_found THEN
                    RAISE EXCEPTION '%', error_message_generic_c USING ERRCODE = error_code_generic_c;
                WHEN too_many_rows THEN
                    RAISE EXCEPTION '%', error_message_generic_c USING ERRCODE = error_code_generic_c;
            END;

            IF ( ie_tipo_local_w = char_eleven_c ) THEN
                BEGIN
                    contador_w := nr_zero_c;
                    << get_main_data_barcode >> BEGIN
                        SELECT
                            mat.ds_material,
                            CASE
                                WHEN mat.ie_tipo_material IN (
                                    nr_one_c,
                                    nr_ten_c
                                ) THEN
                                    nr_one_c
                                ELSE
                                    nr_two_c
                            END producttypeid
                        INTO STRICT
                            ds_material_w,
                            product_type_id_w
                        FROM
                            material mat
                        WHERE
                            mat.cd_material = NEW.cd_material;
                        EXCEPTION
                            WHEN no_data_found THEN
                                RAISE EXCEPTION '%', error_message_generic_c USING ERRCODE = error_code_generic_c;
                            WHEN too_many_rows THEN
                                RAISE EXCEPTION '%', error_message_generic_c USING ERRCODE = error_code_generic_c;

                    END;

                    json_w := json_open_bracket_c
                              || json_open_brace_c
                              || json_customer_code
                              || json_quotation_mark_c
                              || NEW.cd_material
                              || json_quotation_mark_c
                              || json_comma_c
                              || json_name
                              || json_quotation_mark_c
                              || ds_material_w
                              || json_quotation_mark_c
                              || json_comma_c
                              || json_product_type_id
                              || json_quotation_mark_c
                              || product_type_id_w
                              || json_quotation_mark_c
                              || json_comma_c
                              || json_barcodes
                              || json_open_bracket_c;

                    << get_sub_barcodes >> BEGIN
                        << for_build_sub_barcode >> FOR reg_barcodes_cursor IN barcodes_cursor LOOP
                            IF ( contador_w = nr_zero_c ) THEN
                                json_w := json_w
                                          || json_open_brace_c
                                          || json_number
                                          || json_quotation_mark_c
                                          || reg_barcodes_cursor.numberLote
                                          || json_quotation_mark_c
                                          || json_comma_c
                                          || json_expiration_date
                                          || json_quotation_mark_c
                                          || reg_barcodes_cursor.expirationDate
                                          || json_quotation_mark_c
                                          || json_comma_c
                                          || json_batch_number
                                          || json_quotation_mark_c
                                          || reg_barcodes_cursor.batchNumber
                                          || json_quotation_mark_c
                                          || json_comma_c
                                          || json_number_requisition
                                          || NEW.nr_requisicao
                                          || json_comma_c
                                          || json_stock_code
                                          || cd_local_estoque_w
                                          || json_comma_c
                                          || json_code_fornec
                                          || json_quotation_mark_c
                                          || reg_barcodes_cursor.codeFornec
                                          || json_quotation_mark_c
                                          || json_closed_brace_c;

                                contador_w := contador_w + nr_one_c;
                            END IF;

                            IF ( contador_w > nr_zero_c ) THEN
                                json_w := json_w
                                          || json_comma_c
                                          || json_open_brace_c
                                          || json_number
                                          || json_quotation_mark_c
                                          || reg_barcodes_cursor.numberLote
                                          || json_quotation_mark_c
                                          || json_comma_c
                                          || json_expiration_date
                                          || json_quotation_mark_c
                                          || reg_barcodes_cursor.expirationDate
                                          || json_quotation_mark_c
                                          || json_comma_c
                                          || json_batch_number
                                          || json_quotation_mark_c
                                          || reg_barcodes_cursor.batchNumber
                                          || json_quotation_mark_c
                                          || json_comma_c
                                          || json_number_requisition
                                          || NEW.nr_requisicao
                                          || json_comma_c
                                          || json_stock_code
                                          || cd_local_estoque_w
                                          || json_comma_c
                                          || json_code_fornec
                                          || json_quotation_mark_c
                                          || reg_barcodes_cursor.codeFornec
                                          || json_quotation_mark_c
                                          || json_closed_brace_c;

                            END IF;

                        END LOOP for_build_sub_barcode;
                    END;
                    json_w := json_w
                              || json_closed_bracket_c
                              || json_closed_brace_c
                              || json_closed_bracket_c;
                    CALL execute_bifrost_integration(nr_integration_code_c, json_w);
                EXCEPTION
                    WHEN no_data_found THEN
                        RAISE EXCEPTION '%', error_message_generic_c USING ERRCODE = error_code_generic_c;
                END;
            END IF;
        END IF;
        END IF;
    END IF;
  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_execute_dispensary_barcode() FROM PUBLIC;

CREATE TRIGGER execute_dispensary_barcode
	AFTER UPDATE ON item_requisicao_material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_execute_dispensary_barcode();

