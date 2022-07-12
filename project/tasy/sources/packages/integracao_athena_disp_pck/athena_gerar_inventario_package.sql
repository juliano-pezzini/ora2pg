-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE integracao_athena_disp_pck.athena_gerar_inventario ( cd_local_estoque_p bigint, cd_material_p bigint, qt_contagem_p bigint, cd_fornecedor_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text ) AS $body$
DECLARE

		
		ds_erro_w                varchar(2000);
		ie_tipo_entrada_w        varchar(1);
		cd_operacao_estoque_w    bigint;
		dt_mesano_referencia_w   timestamp;
		nr_movimento_w           bigint;
		qt_estoque_w             double precision := 0;
		qt_material_estoque_w    double precision;
		cd_estabelecimento_w     estabelecimento.cd_estabelecimento%TYPE;
		cd_local_estoque_w       smallint;
		
	
BEGIN
		
		BEGIN
			cd_estabelecimento_w := cd_estabelecimento_p;
			dt_mesano_referencia_w := trunc(clock_timestamp(), 'mm');
			IF ( cd_estabelecimento_w = 0 ) THEN
				SELECT MAX(cd_estabelecimento)
				INTO STRICT cd_estabelecimento_w
				FROM parametros_farmacia
				WHERE (cd_pessoa_requisicao IS NOT NULL AND cd_pessoa_requisicao::text <> '');

			END IF;

			SELECT coalesce(MAX(cd_local_estoque), 0)
			INTO STRICT cd_local_estoque_w
			FROM parametros_farmacia
			WHERE cd_estabelecimento = cd_estabelecimento_w;

			IF ( cd_local_estoque_w = 0 ) THEN
				GOTO final;
			END IF;
			obter_saldo_estoque(cd_estabelecimento_w, cd_material_p, cd_local_estoque_w, dt_mesano_referencia_w, qt_estoque_w);
			SELECT ( qt_contagem_p - qt_estoque_w )
			INTO STRICT qt_material_estoque_w
			;

			IF ( coalesce(qt_material_estoque_w, 0) > 0 ) THEN
				ie_tipo_entrada_w := 'E';
			ELSE
				ie_tipo_entrada_w := 'S';
				qt_material_estoque_w := ( qt_material_estoque_w * -1 );
			END IF;

			IF ( coalesce(ie_tipo_entrada_w, 'X') <> 'X' ) THEN
				SELECT MIN(cd_operacao_estoque)
				INTO STRICT cd_operacao_estoque_w
				FROM operacao_estoque
				WHERE ie_tipo_requisicao = 5
				AND ie_entrada_saida = ie_tipo_entrada_w
				AND ie_consignado = '0'
				AND ie_situacao = 'A';

			END IF;

			IF ( coalesce(cd_operacao_estoque_w, 0) <> 0 ) THEN
				BEGIN
					SELECT
						nextval('movimento_estoque_seq')
					INTO STRICT nr_movimento_w
					;

					BEGIN
						INSERT INTO movimento_estoque(
							nr_movimento_estoque,
							cd_estabelecimento,
							cd_local_estoque,
							dt_movimento_estoque,
							cd_operacao_estoque,
							cd_acao,
							cd_material,
							dt_mesano_referencia,
							qt_movimento,
							dt_atualizacao,
							nm_usuario,
							ie_origem_documento,
							ie_origem_proced,
							qt_estoque,
							dt_processo,
							cd_material_estoque,
							qt_inventario,
							ie_movto_consignado,
							ds_observacao
						) VALUES (
							nr_movimento_w,
							cd_estabelecimento_w,
							cd_local_estoque_w,
							clock_timestamp(),
							cd_operacao_estoque_w,
							1,
							cd_material_p,
							dt_mesano_referencia_w,
							qt_material_estoque_w,
							clock_timestamp(),
							nm_usuario_p,
							5,
							1,
							qt_material_estoque_w,
							NULL,
							cd_material_p,
							qt_material_estoque_w,
							'N',
							wheb_mensagem_pck.get_texto(278957)
						);

					EXCEPTION
						WHEN OTHERS THEN
							ds_erro_w := substr(sqlerrm, 1, 2000);
					END;

				END;
			END IF;

			<< final >> ds_erro_p := ds_erro_w;
			COMMIT;
		END;
		
	END;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integracao_athena_disp_pck.athena_gerar_inventario ( cd_local_estoque_p bigint, cd_material_p bigint, qt_contagem_p bigint, cd_fornecedor_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text ) FROM PUBLIC;