-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE add_reg_tc_build_control_plan ( nm_usuario_p text, cd_version_p text, nr_seq_controle_plano_p bigint) AS $body$
DECLARE

cd_funcao_w			varchar(10);
is_function_invalid_w		varchar(10);
ie_contador_w			numeric(20);
nr_seq_pr_w			bigint;
nr_result_w			smallint;
nr_seq_script_w			bigint;
ds_sql_w			varchar(4000);
ds_params_w			varchar(255);
nr_seq_reg_tc_pendencies_w 	bigint;
cd_versao_total_w		varchar(20);
cd_build_w			numeric(20);
ds_version_w			varchar(255);
functions_usadas_w		dbms_sql.number_table;
	
c01 CURSOR FOR
	SELECT  distinct
		b.nr_seq_ordem_serv,
		f.cd_funcao_impacto cd_funcao
	from    MAN_OS_CTRL_BUILD a,
		MAN_OS_CTRL_DESC b,
		man_ordem_serv_impacto c,
		man_ordem_serv_imp_pr d,
		reg_funcao_pr e,
		reg_impacto_funcao f
	where   a.nr_seq_man_os_ctrl_desc = b.nr_sequencia
	and     c.nr_seq_ordem_serv = b.nr_seq_ordem_serv
	and     d.nr_seq_impacto = c.nr_sequencia
	and     e.nr_seq_product_req = d.nr_product_requirement
	and 	e.cd_funcao = f.cd_funcao_origem
	and     e.ie_escopo_teste = 'S'
	and     a.cd_versao =	ds_version_w
	and     a.cd_build = 	cd_build_w
	
union

	SELECT  distinct 
		b.nr_seq_ordem_serv,
		e.cd_funcao cd_funcao
	from    MAN_OS_CTRL_BUILD a,
		MAN_OS_CTRL_DESC b,
		man_ordem_serv_impacto c,
		man_ordem_serv_imp_pr d,
		reg_funcao_pr e
	where   a.nr_seq_man_os_ctrl_desc = b.nr_sequencia
	and     c.nr_seq_ordem_serv = b.nr_seq_ordem_serv
	and     d.nr_seq_impacto = c.nr_sequencia
	and     e.nr_seq_product_req = d.nr_product_requirement
	and     e.ie_escopo_teste = 'S'
	and     a.cd_versao =	ds_version_w
	and     a.cd_build = 	cd_build_w
	order by 2;

c01_w	c01%rowtype;
	
c02 CURSOR(cd_funcao_pc  reg_caso_teste_funcao.cd_funcao%type) FOR
		SELECT	pr.nr_sequencia,
			ctf.cd_funcao,
			ct.nr_seq_test_script,
			ct.nr_sequencia nr_seq_caso_teste
		from	reg_product_requirement pr,
			reg_caso_teste_funcao ctf,
			reg_caso_teste ct
		where	ct.nr_sequencia	= ctf.nr_seq_caso_teste
		and	pr.nr_sequencia	= ct.nr_seq_product
		and 	ctf.cd_funcao = cd_funcao_pc
		and	ct.ie_tipo_execucao = 'A'
		and  	coalesce(ct.ie_situacao,'A') = 'A'
		and  	(ct.dt_liberacao_vv IS NOT NULL AND ct.dt_liberacao_vv::text <> '')
		and   	(ct.dt_aprovacao IS NOT NULL AND ct.dt_aprovacao::text <> '');

c02_w	c02%rowtype;
	
BEGIN

	select	ds_version
	into STRICT	ds_version_w
	from	table(phi_ordem_servico_pck.get_version_info(cd_version_p));

	select	ds_build
	into STRICT	cd_build_w
	from	table(phi_ordem_servico_pck.get_version_info(cd_version_p));

	cd_versao_total_w := ds_version_w || '.' ||cd_build_w;
	ie_contador_w := 0;

	for r_c01_w in C01() loop
		begin
				is_function_invalid_w := 'N';
				ie_contador_w := ie_contador_w + 1;
				functions_usadas_w(ie_contador_w) := r_c01_w.cd_funcao;
				
				FOR i IN functions_usadas_w.FIRST .. (functions_usadas_w.LAST -1)
					LOOP
						if (i = r_c01_w.cd_funcao) then
							is_function_invalid_w := 'S';
						end if;
					END LOOP;
				for r_c02_w in C02(r_c01_w.cd_funcao) loop
					begin
		
						ds_sql_w :=	'select	1 '
							||	'from	schem_test_script@schematic4test sts '
							||	'where	sts.nr_sequencia = :nr_seq_script '
							||	'and	to_number(substr(:cd_version, 6, 4)) >= to_number(sts.ds_version)';
	
						ds_params_w := 'nr_seq_script=' || r_c02_w.nr_seq_test_script ||';cd_version=' ||ds_version_w;
	
						nr_result_w := obter_valor_dinamico_bv(ds_sql_w, ds_params_w, nr_result_w);
	
						if (	(r_c02_w.nr_sequencia IS NOT NULL AND r_c02_w.nr_sequencia::text <> '')
							and	nr_result_w > 0)	then

							select	nextval('reg_tc_pendencies_seq')
							into STRICT	nr_seq_reg_tc_pendencies_w
							;
							
							if (is_function_invalid_w <> 'S') then
								insert
								into reg_tc_pendencies(
										nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										dt_atualizacao_nrec,
										nm_usuario_nrec,
										nr_seq_tc,
										nr_seq_pr,
										ds_version,
										cd_funcao,
										ie_status,
										ie_tipo_mudanca,
										nr_seq_controle_plano
									)
									values (
										nr_seq_reg_tc_pendencies_w,
										clock_timestamp(),
										nm_usuario_p,
										clock_timestamp(),
										nm_usuario_p,
										r_c02_w.nr_seq_caso_teste,
										r_c02_w.nr_sequencia,
										cd_versao_total_w,
										r_c02_w.cd_funcao,
										'P',
										'SP',
										nr_seq_controle_plano_p
									);
							end if;
								
							insert
							into reg_tc_so_dev(
									nr_sequencia,
									dt_atualizacao,
									nm_usuario,
									dt_atualizacao_nrec,
									nm_usuario_nrec,
									nr_seq_service_order,
									nr_seq_pendency)
								values (								
									nextval('reg_tc_so_dev_seq'), 
									clock_timestamp(),
									nm_usuario_p,
									clock_timestamp(),
									nm_usuario_p,
									r_c01_w.nr_seq_ordem_serv, 
									nr_seq_reg_tc_pendencies_w
								);
	
						end if;
					end;
				end loop;	
			commit;
		end;
	end loop;
		
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE add_reg_tc_build_control_plan ( nm_usuario_p text, cd_version_p text, nr_seq_controle_plano_p bigint) FROM PUBLIC;

