-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function gerar_int_dankia_pck.dankia_disp_barras_req() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE gerar_int_dankia_pck.dankia_disp_barras_req ( cd_material_p bigint, nr_lote_fornec_p bigint, qt_baixar_p bigint, cd_barras_p text, nm_usuario_p text, cd_local_estoque_p bigint default null) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL gerar_int_dankia_pck.dankia_disp_barras_req_atx ( ' || quote_nullable(cd_material_p) || ',' || quote_nullable(nr_lote_fornec_p) || ',' || quote_nullable(qt_baixar_p) || ',' || quote_nullable(cd_barras_p) || ',' || quote_nullable(nm_usuario_p) || ',' || quote_nullable(cd_local_estoque_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE gerar_int_dankia_pck.dankia_disp_barras_req_atx ( cd_material_p bigint, nr_lote_fornec_p bigint, qt_baixar_p bigint, cd_barras_p text, nm_usuario_p text, cd_local_estoque_p bigint default null) AS $body$
DECLARE
ie_integra_w	varchar(1) := 'N';
	qt_existe_ww	bigint := 0;
	
	
BEGIN

	if (get_ie_int_dankia = 'S') then
		select	count(1)
		into STRICT	qt_existe_ww
		from	dankia_disp_material
		where	coalesce(cd_material_generico, cd_material) = cd_material_p;
		
		if (cd_local_estoque_p IS NOT NULL AND cd_local_estoque_p::text <> '') and (gerar_int_dankia_pck.get_ie_local_dankia(cd_local_estoque_p) = 'S') and (qt_existe_ww > 0)then
			ie_integra_w := 'S';
		elsif (qt_existe_ww > 0) then
			ie_integra_w := 'S';
		end if;
		
		if (ie_integra_w = 'S') then
		
			select	max(cd_barra_material)
			into STRICT	cd_barras_generico_w
			from	material_cod_barra
			where 	cd_material in (SELECT max(cd_material_generico) from material where cd_material = cd_material_p);
			
			select	max(b.cd_unidade_medida_consumo)
			into STRICT	current_setting('gerar_int_dankia_pck.cd_unidade_medida_w')::material.cd_unidade_medida_consumo%type
			from	material b
			where 	b.cd_material = cd_material_p;

			select	max(dt_validade),
				max(cd_estabelecimento)
			into STRICT	dt_validade_w,
				cd_estab_w
			from	material_lote_fornec
			where	nr_sequencia = nr_lote_fornec_p;
			
			cd_barras_mat_w := cd_barras_p;
			
			if (nr_lote_fornec_p IS NOT NULL AND nr_lote_fornec_p::text <> '') and (coalesce(cd_barras_p::text, '') = '') then
				
				select	max(lpad(nr_lote_fornec_p || nr_digito_verif,11,0)),
						max(cd_barra_material)
				into STRICT	cd_barras_mat_w,
						cd_lote_w
				from	material_lote_fornec
				where	nr_sequencia = nr_lote_fornec_p;
				
			end if;
						
			insert into dankia_disp_barras(
						nr_sequencia,
						cd_estabelecimento,
						dt_atualizacao,
						nm_usuario,
						dt_lido_dankia,
						dt_validade,
						cd_material,
						cd_tipo,
						cd_barras_generico,
						cd_barras,
						cd_unidade_medida,
						ds_unidade,
						vl_fator,
						cd_lote,
						nr_seq_lote,
						ie_operacao,
						ie_processado,
						ds_processado_observacao,
						ds_stack)
				values (	nextval('dankia_disp_barras_seq'),
						coalesce(wheb_usuario_pck.get_cd_estabelecimento,cd_estab_w),
						clock_timestamp(),
						nm_usuario_p,
						null,
						dt_validade_w,
						cd_material_p,
						CASE WHEN coalesce(nr_lote_fornec_p::text, '') = '' THEN 'M'  ELSE 'F' END ,
						cd_barras_generico_w,
						coalesce(cd_barras_mat_w,cd_material_p),
						current_setting('gerar_int_dankia_pck.cd_unidade_medida_w')::material.cd_unidade_medida_consumo%type,
						substr(obter_desc_unidade_medida(current_setting('gerar_int_dankia_pck.cd_unidade_medida_w')::material.cd_unidade_medida_consumo%type),1,40),
						qt_baixar_p,
						cd_lote_w,--lote
						nr_lote_fornec_p,
						'I',
						'N',
						null,
						substr(dbms_utility.format_call_stack,1,2000));
		end if;
	commit;
	end if;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_int_dankia_pck.dankia_disp_barras_req ( cd_material_p bigint, nr_lote_fornec_p bigint, qt_baixar_p bigint, cd_barras_p text, nm_usuario_p text, cd_local_estoque_p bigint default null) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE gerar_int_dankia_pck.dankia_disp_barras_req_atx ( cd_material_p bigint, nr_lote_fornec_p bigint, qt_baixar_p bigint, cd_barras_p text, nm_usuario_p text, cd_local_estoque_p bigint default null) FROM PUBLIC;