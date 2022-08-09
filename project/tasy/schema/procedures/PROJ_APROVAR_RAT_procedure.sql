-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_aprovar_rat ( nr_seq_rat_p bigint, nm_usuario_p text) AS $body$
DECLARE



qt_hora_cobrar_w		double precision;
vl_hora_cobrar_w		double precision;
vl_hora_w		double precision;
vl_pagar_w		double precision;
vl_parametro_p		varchar(1);	
nr_seq_cliente_w		bigint;
cd_consultor_w		varchar(10);
dt_final_rat_w		timestamp;
ie_paga_rat_w		varchar(01);
ie_funcao_exec_w		varchar(15);
NR_SEQ_PROJ_w		bigint;
qt_valida_w		bigint;
ie_regime_contr_w	proj_rat.ie_regime_contr%type;

C01 CURSOR FOR
	SELECT	vl_hora
	from	proj_consultor_aval
	where	nr_seq_cliente		= nr_seq_cliente_w
	and	cd_consultor		= cd_consultor_w
	and	dt_inicio_validade		<= dt_final_rat_w
	and	ie_funcao_exec		= ie_funcao_exec_w
	order by dt_inicio_validade;


BEGIN

select	cd_executor,
	nr_seq_cliente,
	dt_final,
	qt_hora_cobrar,
	ie_paga_rat,
	coalesce(ie_funcao_exec,'CONSULT'),
	NR_SEQ_PROJ,
	ie_regime_contr
into STRICT	cd_consultor_w,
	nr_seq_cliente_w,
	dt_final_rat_w,
	qt_hora_cobrar_w,
	ie_paga_rat_w,
	ie_funcao_exec_w,
	NR_SEQ_PROJ_w,
	ie_regime_contr_w
from	proj_rat
where	nr_sequencia	= nr_seq_rat_p;

open c01;
loop
fetch c01 into
	vl_hora_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	vl_hora_w	:= vl_hora_w;
	end;
end loop;
close c01;

select	Obter_Hora_RAT_Cobrar(NR_SEQ_PROJ_w, cd_consultor_w, dt_final_rat_w)
into STRICT	vl_hora_cobrar_w
;

vl_pagar_w	:= vl_hora_w * qt_hora_cobrar_w;

vl_parametro_p := Obter_Param_Usuario(993, 151, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, vl_parametro_p);

if ((vl_parametro_p IS NOT NULL AND vl_parametro_p::text <> '') or vl_parametro_p <> '') then
	
	select	count(nr_sequencia)
	into STRICT	qt_valida_w
	from	proj_rat  a
	where	nr_sequencia	= nr_seq_rat_p	
	and	exists (SELECT	1			
			from	proj_consultor_aval b
			where	cd_consultor = cd_consultor_w
			and	nr_seq_proj = nr_seq_proj_w
			and	b.dt_inicio_validade between(a.dt_inicio-(vl_parametro_p)::numeric ) and a.dt_final);
			
	if (qt_valida_w = 0) then
		CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(284281);
	end if;

end if;

if (ie_regime_contr_w = 'PJ') then
	vl_hora_w	:= 0;
	vl_pagar_w	:= 0;
end if;

update	proj_rat
set	vl_hora_pagar	= vl_hora_w,
	vl_pagar		= vl_pagar_w,
	vl_hora_cobrar	= vl_hora_cobrar_w,
	dt_aprovacao	= clock_timestamp(),
	nm_usuario_aprov	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p
where	nr_sequencia	= nr_seq_rat_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_aprovar_rat ( nr_seq_rat_p bigint, nm_usuario_p text) FROM PUBLIC;
