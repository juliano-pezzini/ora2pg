-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gera_eventos_glosa () AS $body$
DECLARE


tb_cd_motivo_tiss_w		pls_util_cta_pck.t_varchar2_table_20;
tb_ie_evento_w			pls_util_cta_pck.t_varchar2_table_20;
tb_ie_plano_w			pls_util_cta_pck.t_varchar2_table_20;
tb_ie_plano_versao_w		pls_util_cta_pck.t_varchar2_table_20;
tb_ie_vai_versao_w		pls_util_cta_pck.t_varchar2_table_20;
tb_nm_usuario_nrec_w		pls_util_cta_pck.t_varchar2_table_20;
tb_nr_seq_motivo_glosa_w	pls_util_cta_pck.t_number_table;

valor_bind_w			sql_pck.t_dado_bind;
cursor_w			sql_pck.t_cursor;
ds_sql_w			varchar(4000);
ie_ctrl_estab_w			pls_controle_estab.ie_ocorrencia%type;

C01 CURSOR FOR
	SELECT	cd_estabelecimento
	from	estabelecimento
	where	ie_ctrl_estab_w	= 'S'
	
union all

	SELECT	cd_estabelecimento
	from	estabelecimento
	where	coalesce(ie_ctrl_estab_w,'N')= 'N'
	and	cd_estabelecimento	= (select max(cd_estabelecimento)
					   from	  pls_outorgante);

BEGIN

select	max(ie_ocorrencia)
into STRICT	ie_ctrl_estab_w
from	pls_controle_estab;

begin
	for r_C01_w in C01 loop

		ds_sql_w := 	'	select	cd_motivo_tiss, 									' || pls_util_pck.enter_w ||
				'		ie_evento,										' || pls_util_pck.enter_w ||
				'		max(ie_plano),										' || pls_util_pck.enter_w ||
				'		max(ie_plano_versao),									' || pls_util_pck.enter_w ||
				'		max(ie_vai_versao),									' || pls_util_pck.enter_w ||
				'		nr_seq_motivo_glosa,									' || pls_util_pck.enter_w ||
				'		max(nm_usuario_nrec) 									' || pls_util_pck.enter_w ||
				'	from	pls_glosa_evento a									' || pls_util_pck.enter_w ||
				'	where	nvl(a.ie_vai_versao,''S'') = ''S''							' || pls_util_pck.enter_w ||
				'	and	a.cd_motivo_tiss >= ''1001''								' || pls_util_pck.enter_w ||
				'	and	not exists (	select	1 								' || pls_util_pck.enter_w ||
				'				from	pls_glosa_evento b						' || pls_util_pck.enter_w ||
				'				where	b.ie_evento = a.ie_evento					' || pls_util_pck.enter_w ||
				'				and	b.nr_seq_motivo_glosa = a.nr_seq_motivo_glosa			' || pls_util_pck.enter_w ||
				'				and	b.cd_estabelecimento = ' || r_C01_w.cd_estabelecimento || ')	' || pls_util_pck.enter_w ||
				'	group by cd_motivo_tiss, ie_evento, nr_seq_motivo_glosa						';

		valor_bind_w := sql_pck.executa_sql_cursor(ds_sql_w, valor_bind_w);

		loop
			fetch cursor_w bulk collect into
						tb_cd_motivo_tiss_w,
						tb_ie_evento_w,
						tb_ie_plano_w,
						tb_ie_plano_versao_w,
						tb_ie_vai_versao_w,
						tb_nr_seq_motivo_glosa_w,
						tb_nm_usuario_nrec_w
			limit 500;

			exit when tb_cd_motivo_tiss_w.count = 0;

			begin
				forall i in tb_cd_motivo_tiss_w.first .. tb_cd_motivo_tiss_w.last
					insert	into	pls_glosa_evento(	cd_estabelecimento, cd_motivo_tiss, dt_atualizacao,
							dt_atualizacao_nrec, ie_evento, ie_plano,
							ie_plano_versao, ie_vai_versao, nm_usuario,
							nm_usuario_nrec, nr_seq_motivo_glosa, nr_sequencia)
					values (	r_C01_w.cd_estabelecimento, tb_cd_motivo_tiss_w(i), clock_timestamp(),
							clock_timestamp(), tb_ie_evento_w(i), tb_ie_plano_w(i),
							tb_ie_plano_versao_w(i), tb_ie_vai_versao_w(i), coalesce(coalesce(tb_nm_usuario_nrec_w(i), wheb_usuario_pck.get_nm_usuario), 'Tasy'),
							tb_nm_usuario_nrec_w(i), tb_nr_seq_motivo_glosa_w(i), nextval('pls_glosa_evento_seq'));
				commit;
			exception
			when others then
				null;
			end;
		end loop;
		close cursor_w;
	end loop;
exception
when others then
	null;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gera_eventos_glosa () FROM PUBLIC;

