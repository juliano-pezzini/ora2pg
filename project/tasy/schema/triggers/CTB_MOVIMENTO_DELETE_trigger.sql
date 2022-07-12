-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS ctb_movimento_delete ON ctb_movimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_ctb_movimento_delete() RETURNS trigger AS $BODY$
BEGIN
/*
O movimento foi gerado a partir de um documento contabil,
por isso se a contabilizacao for desfeita, o documento precisa ser marcado como Nao contabilizado.
*/

if (coalesce(wheb_usuario_pck.get_ie_executar_trigger, 'S') = 'S') then
        if (OLD.ie_status_origem = 'SO') then
                update  ctb_documento
                set     ie_situacao_ctb  = 'P',
                        nr_lote_contabil  = NULL
                where   nr_sequencia in (
                                        SELECT  y.nr_seq_ctb_documento
                                        from    movimento_contabil_doc y
                                        where   y.nr_seq_ctb_movto = OLD.nr_sequencia
                                        and     y.nr_lote_contabil = OLD.nr_lote_contabil);

                delete  FROM movimento_contabil_doc
                where   nr_seq_ctb_movto = OLD.nr_sequencia
                and     nr_seq_ctb_documento is not null;

        end if;
end if;

RETURN OLD;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_ctb_movimento_delete() FROM PUBLIC;

CREATE TRIGGER ctb_movimento_delete
	AFTER DELETE ON ctb_movimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_ctb_movimento_delete();

