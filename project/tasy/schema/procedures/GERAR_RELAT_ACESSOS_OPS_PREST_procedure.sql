-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE dados AS (	nm_maquina		varchar(255),
			dt_acesso		timestamp,
			qt_operadora		bigint,
			qt_prestadora		bigint);


CREATE OR REPLACE PROCEDURE gerar_relat_acessos_ops_prest ( dt_inicial_p timestamp, dt_final_p timestamp, pr_diferenca_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_count_w		integer;
nm_maquina_w		varchar(255);
nr_seq_acesso_w		bigint;
qt_acesso_operadora_w	bigint;
qt_acesso_prestadora_w	bigint;
i			integer;
ds_sep_bv_w		varchar(50);
qt_acessos_total_w	bigint;
pr_acessos_operadora_w	double precision;
pr_acessos_prestadora_w	double precision;
dt_acesso_w		timestamp;
type Vetor is table of dados index by integer;
vt_dados_w		Vetor;



C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_acesso,
		CASE WHEN a.cd_aplicacao_tasy='AvaliacaoPacienteWeb' THEN  a.ds_maquina || ':' || a.cd_aplicacao_tasy WHEN a.cd_aplicacao_tasy='BibliotecasWeb' THEN  a.ds_maquina || ':' || a.cd_aplicacao_tasy WHEN a.cd_aplicacao_tasy='CotacaoCompraWeb' THEN  a.ds_maquina || ':' || a.cd_aplicacao_tasy WHEN a.cd_aplicacao_tasy='LaboratorioWeb' THEN  a.ds_maquina || ':' || a.cd_aplicacao_tasy WHEN a.cd_aplicacao_tasy='PalmWeb' THEN  a.ds_maquina || ':' || a.cd_aplicacao_tasy WHEN a.cd_aplicacao_tasy='TasyWeb' THEN  a.ds_maquina || ':' || a.cd_aplicacao_tasy WHEN a.cd_aplicacao_tasy='WhebPortal' THEN  a.ds_maquina || ':' || a.cd_aplicacao_tasy  ELSE lower(CASE WHEN a.nm_maq_cliente='Console' THEN  a.ds_maquina  ELSE a.nm_maq_cliente END ) END  nm_maquina
	from	tasy_log_acesso a
	where	a.dt_acesso between dt_inicial_p and fim_dia(dt_final_p);





	procedure	adiciona_registro_vetor(	nm_maquina_p	text,
							qt_operadora_p	bigint,
							qt_prestadora_p	bigint,
							dt_acesso_p	timestamp) is
	ie_encontrou_w	boolean;
	qt_total_w	bigint;
	pr_operadora_w	double precision;
	pr_prestadora_w	double precision;
	qt_operadora_w	smallint;
	qt_prestadora_w	smallint;
	
BEGIN

	qt_total_w	:= qt_operadora_p + qt_prestadora_p;
	pr_operadora_w	:= 0;
	pr_prestadora_w	:= 0;
	qt_operadora_w	:= 0;
	qt_prestadora_w	:= 0;

	if (qt_total_w > 0) then
		pr_operadora_w	:= (qt_operadora_p * 100) / qt_total_w;
		pr_prestadora_w	:= (qt_prestadora_p * 100) / qt_total_w;
	end if;

	if (pr_operadora_w >= pr_prestadora_w) then
		qt_operadora_w	:= 1;
		if	((pr_operadora_w - pr_prestadora_w) <= pr_diferenca_p) then
			qt_prestadora_w	:= 1;
		end if;
	else
		qt_prestadora_w	:= 1;
		if	((pr_prestadora_w - pr_operadora_w) <= pr_diferenca_p) then
			qt_operadora_w	:= 1;
		end if;
	end if;

	ie_encontrou_w := False;
	for i in 1..vt_dados_w.Count loop
		if (vt_dados_w[i].nm_maquina = nm_maquina_p) then
			if (vt_dados_w[i].dt_acesso > dt_acesso_p) then
				vt_dados_w[i].dt_acesso := dt_acesso_p;
			end if;
			vt_dados_w[i].qt_operadora	:= vt_dados_w[i].qt_operadora + qt_operadora_w;
			vt_dados_w[i].qt_prestadora	:= vt_dados_w[i].qt_prestadora + qt_prestadora_w;
			ie_encontrou_w := True;
		end if;
	end loop;

	if not ie_encontrou_w then
		i	:= vt_dados_w.Count+1;
		vt_dados_w[i].nm_maquina	:= nm_maquina_p;
		vt_dados_w[i].dt_acesso		:= dt_acesso_p;
		vt_dados_w[i].qt_operadora	:= qt_operadora_w;
		vt_dados_w[i].qt_prestadora	:= qt_prestadora_w;
	end if;
	end;

begin

open C01;
loop
fetch C01 into
	nr_seq_acesso_w,
	dt_acesso_w,
	nm_maquina_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	count(1)
	into STRICT	qt_acesso_operadora_w
	from	log_acesso_funcao b,
		funcao c
	where	b.nr_seq_acesso = nr_seq_acesso_w
	and	c.cd_funcao = b.cd_funcao
	and	coalesce(c.ie_classif_produto,'A') = 'P';
	--and 	c.ds_aplicacao = 'TasyPLS';
	select	count(1)
	into STRICT	qt_acesso_prestadora_w
	from	log_acesso_funcao b,
		funcao c
	where	b.nr_seq_acesso = nr_seq_acesso_w
	and	c.cd_funcao = b.cd_funcao
	and	coalesce(c.ie_classif_produto,'A') = 'O';
	--and 	c.ds_aplicacao <> 'TasyPLS';
	if (qt_acesso_operadora_w > 0) or (qt_acesso_prestadora_w > 0) then
		adiciona_registro_vetor(nm_maquina_w, qt_acesso_operadora_w, qt_acesso_prestadora_w, dt_acesso_w);
	end if;
	end;
end loop;
close C01;

select	count(table_name)
into STRICT	nr_count_w
from	user_tables
where	upper(table_name) = 'RELAT_ACESSOS_OPS_PREST';

if (nr_count_w	= 0) then
	CALL exec_sql_dinamico(nm_usuario_p,'create table RELAT_ACESSOS_OPS_PREST(	nm_usuario		varchar2(15),
										dt_acesso		date,
										nm_maquina		varchar2(255),
										qt_operadora		number(15,0),
										qt_prestadora		number(15,0),
										pr_operadora		number(15,5),
										pr_prestadora		number(15,5))');
else
	CALL exec_sql_dinamico(nm_usuario_p,'delete from RELAT_ACESSOS_OPS_PREST where nm_usuario = ' || chr(39) || nm_usuario_p || chr(39));
end if;

ds_sep_bv_w	:= obter_separador_bv;

for i in 1..vt_dados_w.Count loop

	qt_acessos_total_w	:= vt_dados_w[i].qt_operadora + vt_dados_w[i].qt_prestadora;
	pr_acessos_operadora_w	:= 0;
	pr_acessos_prestadora_w	:= 0;

	if (qt_acessos_total_w > 0) then
		pr_acessos_operadora_w	:= round((vt_dados_w[i].qt_operadora * 100) / qt_acessos_total_w,2);
		pr_acessos_prestadora_w	:= round((vt_dados_w[i].qt_prestadora * 100) / qt_acessos_total_w,2);
	end if;

	if (pr_acessos_operadora_w > 0) or (pr_acessos_prestadora_w > 0) then
		CALL exec_sql_dinamico_bv(	nm_usuario_p,
					'insert into RELAT_ACESSOS_OPS_PREST (nm_usuario, dt_acesso, nm_maquina, qt_operadora, qt_prestadora, pr_operadora, pr_prestadora) '||
					'values (:nm_usuario, :dt_acesso, :nm_maquina, :qt_operadora, :qt_prestadora, :pr_operadora, :pr_prestadora)',
					'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
					'dt_acesso=' || to_char(vt_dados_w[i].dt_acesso,'dd/mm/yyyy hh24:mi:ss') || ds_sep_bv_w ||
					'nm_maquina=' || vt_dados_w[i].nm_maquina || ds_sep_bv_w ||
					'qt_operadora=' || to_char(vt_dados_w[i].qt_operadora) || ds_sep_bv_w ||
					'qt_prestadora=' || to_char(vt_dados_w[i].qt_prestadora) || ds_sep_bv_w ||
					'pr_operadora=' || to_char(pr_acessos_operadora_w) || ds_sep_bv_w ||
					'pr_prestadora=' || to_char(pr_acessos_prestadora_w));
		commit;
	end if;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_relat_acessos_ops_prest ( dt_inicial_p timestamp, dt_final_p timestamp, pr_diferenca_p bigint, nm_usuario_p text) FROM PUBLIC;

