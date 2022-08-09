-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_valor_proc_seq ( nr_sequencia_p bigint) AS $body$
DECLARE




nr_sequencia_w		bigint;
vl_procedimento_w		double precision;
vl_participante_w		double precision;
vl_medico_conta_w		double precision;
vl_medico_w			double precision;
vl_materiais_w			double precision;
vl_custo_operacional_w		double precision;
ie_calcula_honorario_w		varchar(1)	:= 'S';
ie_conta_honorario_w		varchar(1);
ie_classificacao_w		bigint;

C01 CURSOR FOR
	SELECT 		a.nr_sequencia,
			coalesce(a.vl_medico,0),
			coalesce(a.vl_materiais,0),
			coalesce(a.vl_custo_operacional,0),
			b.ie_entra_conta,
			b.ie_calcula_valor,
			coalesce(a.vl_procedimento,0)
	from		regra_honorario b,
			procedimento_paciente a
	where		a.nr_sequencia = nr_sequencia_p
	and		coalesce(cd_motivo_exc_conta::text, '') = ''
	and		coalesce(nr_seq_proc_pacote::text, '') = ''
	and		a.ie_responsavel_credito = b.cd_regra;


C02 CURSOR FOR
	SELECT		nr_sequencia,
			coalesce(vl_medico,0) +
			coalesce(vl_auxiliares,0) +
			coalesce(vl_anestesista,0) +
			coalesce(vl_materiais,0) +
			coalesce(vl_custo_operacional,0),
			b.ie_classificacao
	from		procedimento_paciente a,
			procedimento b
	where	a.cd_procedimento	= b.cd_procedimento
	and		a.ie_origem_proced	= b.ie_origem_proced
	and		a.nr_sequencia = nr_sequencia_p
	and		coalesce(cd_motivo_exc_conta::text, '') = ''
	and		coalesce(ie_responsavel_credito::text, '') = ''
	and		coalesce(nr_seq_proc_pacote::text, '') = '';


BEGIN

OPEN C01;
LOOP
FETCH C01 into
	nr_sequencia_w,
	vl_medico_w,
	vl_materiais_w,
	vl_custo_operacional_w,
	ie_conta_honorario_w,
	ie_calcula_honorario_w,
	vl_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	vl_medico_conta_w	:= 0;
	if (ie_conta_honorario_w 		= 'S') 	then
		vl_medico_conta_w 		:= vl_medico_w;
	end if;
	if (ie_conta_honorario_w		= 'T') 	then
		vl_procedimento_w		:= 0;
	elsif (vl_custo_operacional_w	> 0) or (vl_medico_w 		> 0) or (vl_materiais_w		> 0)  then
		vl_procedimento_w	:= 	(vl_custo_operacional_w  + vl_medico_conta_w + vl_materiais_w);
	end if;

	select	coalesce(sum(vl_Conta),0)
	into STRICT	vl_participante_w
	from	procedimento_participante
	where	nr_sequencia		= nr_sequencia_w;

	update	procedimento_paciente
	set	vl_procedimento		= vl_procedimento_w + vl_participante_w
	where	nr_sequencia 		= nr_sequencia_w;


	end;
END LOOP;
close c01;

open C02;
loop
fetch C02 into
	nr_sequencia_w,
	vl_procedimento_w,
	ie_classificacao_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	if (ie_classificacao_w	= 1) then
		select	coalesce(sum(vl_Conta),0)
		into STRICT	vl_participante_w
		from	procedimento_participante
		where	nr_sequencia		= nr_sequencia_w;

		update	procedimento_paciente
		set	vl_procedimento	= vl_procedimento_w + vl_participante_w
		where	nr_sequencia 		= nr_sequencia_w;
	end if;
	end;
end loop;
close C02;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_valor_proc_seq ( nr_sequencia_p bigint) FROM PUBLIC;
