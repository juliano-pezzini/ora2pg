-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_preco_amb_rel ( cd_edicao_amb_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_especialidade_p bigint, dt_inicio_vigencia_p timestamp) AS $body$
DECLARE


dt_atualizacao_w			timestamp		:= clock_timestamp();
qt_pontos_w			preco_amb.qt_pontuacao%type;
cd_procedimento_w		bigint	:= 0;
vl_procedimento_w			double precision 	:= 0;
vl_custo_operacional_w		double precision 	:= 0;
vl_anestesista_w			double precision 	:= 0;
vl_medico_w			double precision 	:= 0;
vl_auxiliares_w			double precision 	:= 0;
vl_filme_w			double precision 	:= 0;
qt_filme_w			double precision 	:= 0;
nr_auxiliares_w			smallint    	:= 0;
nr_incidencia_w			smallint    	:= 0;
qt_porte_anestesico_w		smallint    	:= 0;
cd_estabelecimento_w		smallint    	:= 1;
vl_pto_custo_operac_w		double precision 	:= 0;
vl_pto_procedimento_w		double precision 	:= 0;
vl_pto_anestesista_w		double precision 	:= 0;
vl_pto_medico_w			double precision 	:= 0;
vl_pto_auxiliares_w			double precision 	:= 0;
vl_pto_materiais_w			double precision	:= 0;
cd_edicao_amb_w			integer	:= 0;
nr_porte_anestesico_w		smallint	:= 0;
ie_origem_proced_w		bigint;
cd_usuario_convenio_w		varchar(40);
cd_plano_w			varchar(20);
ie_clinica_w			bigint;
cd_empresa_ref_w			bigint;
ie_preco_informado_w		varchar(01);
nr_seq_ajuste_proc_w		bigint;

c01 CURSOR FOR
SELECT	a.cd_procedimento,
	a.qt_filme,
	a.nr_auxiliares,
	a.nr_incidencia,
	a.qt_porte_anestesico,
	a.ie_origem_proced
from	grupo_proc b,
	procedimento c,
	preco_amb a
where	a.cd_edicao_amb    	= cd_edicao_amb_p
and	a.cd_procedimento  	= c.cd_procedimento
and	a.ie_origem_proced	= c.ie_origem_proced
and	b.cd_grupo_proc    	= c.cd_grupo_proc
and	b.cd_especialidade 	= coalesce(cd_especialidade_p,-1)
and	coalesce(a.dt_inicio_vigencia, clock_timestamp())	= (
			SELECT 	max( coalesce( x.dt_inicio_vigencia, clock_timestamp()) )
			from	preco_amb x
			where	x.cd_procedimento 	= a.cd_procedimento
			and	x.ie_origem_proced	= a.ie_origem_proced
			and	x.cd_edicao_amb    	= cd_edicao_amb_p
			and	coalesce( x.dt_inicio_vigencia, clock_timestamp())	<= coalesce(dt_inicio_vigencia_p, coalesce( x.dt_inicio_vigencia, clock_timestamp()) )
			)

union

select	a.cd_procedimento,
	a.qt_filme,
	a.nr_auxiliares,
	a.nr_incidencia,
	a.qt_porte_anestesico,
	a.ie_origem_proced
from	preco_amb a
where	a.cd_edicao_amb    	= cd_edicao_amb_p
and	coalesce(cd_especialidade_p,-1) 	= -1
and	coalesce( a.dt_inicio_vigencia, clock_timestamp())	= (
			select 	max( coalesce( x.dt_inicio_vigencia, clock_timestamp()) )
			from	preco_amb x
			where	x.cd_procedimento 	= a.cd_procedimento
			and	x.ie_origem_proced	= a.ie_origem_proced
			and	x.cd_edicao_amb    	= cd_edicao_amb_p
			and	coalesce( x.dt_inicio_vigencia, clock_timestamp())	<= coalesce( dt_inicio_vigencia_p, coalesce( x.dt_inicio_vigencia, clock_timestamp()) )
			);



BEGIN

/* limpar tabela w_preco_amb */

begin
delete from w_preco_amb;
commit;
end;

if	coalesce(cd_convenio_p,0) <> 0 and
	coalesce(cd_categoria_p,'0') <> '0' then

	/* gerar tabela w_preco_amb a partir da preco_amb */

	open C01;
	loop
	fetch C01 into
		cd_procedimento_w,
		qt_filme_w,
		nr_auxiliares_w,
		nr_incidencia_w,
		qt_porte_anestesico_w,
		ie_origem_proced_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		SELECT * FROM define_preco_procedimento(cd_estabelecimento_w, cd_convenio_p, cd_categoria_p, dt_atualizacao_w, cd_procedimento_w, null, null, null, null, null, null, null, null, cd_usuario_convenio_w, cd_plano_w, ie_clinica_w, cd_empresa_ref_w, null, vl_procedimento_w, vl_custo_operacional_w, vl_anestesista_w, vl_medico_w, vl_auxiliares_w, vl_filme_w, vl_pto_procedimento_w, vl_pto_custo_operac_w, vl_pto_anestesista_w, vl_pto_medico_w, vl_pto_auxiliares_w, vl_pto_materiais_w, nr_porte_anestesico_w, qt_pontos_w, cd_edicao_amb_w, ie_preco_informado_w, nr_seq_ajuste_proc_w, 0, null, 0, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null) INTO STRICT vl_procedimento_w, vl_custo_operacional_w, vl_anestesista_w, vl_medico_w, vl_auxiliares_w, vl_filme_w, vl_pto_procedimento_w, vl_pto_custo_operac_w, vl_pto_anestesista_w, vl_pto_medico_w, vl_pto_auxiliares_w, vl_pto_materiais_w, nr_porte_anestesico_w, qt_pontos_w, cd_edicao_amb_w, ie_preco_informado_w, nr_seq_ajuste_proc_w;

		insert into w_preco_amb(
					cd_edicao_amb,
					cd_procedimento,
					vl_procedimento,
					vl_custo_operacional,
					vl_anestesista,
					vl_medico,
					vl_filme,
					qt_filme,
					nr_auxiliares,
					nr_incidencia,
					qt_porte_anestesico,
					ie_origem_proced,
					vl_auxiliares)
				values (
					cd_edicao_amb_p,
					cd_procedimento_w,
					coalesce(vl_procedimento_w,0),
					vl_custo_operacional_w,
					vl_anestesista_w,
					vl_medico_w,
					vl_filme_w,
					qt_filme_w,
					nr_auxiliares_w,
					nr_incidencia_w,
					qt_porte_anestesico_w,
					ie_origem_proced_w,
					vl_auxiliares_w);
		end;
	end loop;
	close C01;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_preco_amb_rel ( cd_edicao_amb_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_especialidade_p bigint, dt_inicio_vigencia_p timestamp) FROM PUBLIC;
