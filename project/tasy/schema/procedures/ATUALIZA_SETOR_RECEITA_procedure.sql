-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_setor_receita (nr_interno_conta_p bigint) AS $body$
DECLARE


nr_atendimento_w		bigint := 0;
ie_tipo_atendimento_w	smallint := 0;
cd_setor_internacao_w	integer := 0;
ie_tipo_convenio_w	smallint := 0;


BEGIN

begin
select	b.ie_tipo_convenio
into STRICT		ie_tipo_convenio_w
from		conta_paciente a,
		convenio b
where		a.cd_convenio_calculo 	= b.cd_convenio
and		a.nr_interno_conta	= nr_interno_conta_p;
exception
		when others then
		ie_tipo_convenio_w := 0;
end;

select 	a.nr_atendimento,
    		a.ie_tipo_atendimento
into STRICT		nr_atendimento_w,
		ie_tipo_atendimento_w
from		atendimento_paciente a,
		conta_paciente b
where 	a.nr_atendimento = b.nr_atendimento
  and 	b.nr_interno_conta = nr_interno_conta_p;

update 	material_atend_paciente
set 		cd_setor_receita 	= cd_setor_atendimento
where 	nr_interno_conta 	= nr_interno_conta_p
  and       coalesce(cd_setor_receita,0)	<> cd_setor_atendimento;

update 	procedimento_paciente
set 		cd_setor_receita 	= cd_setor_atendimento
where 	nr_interno_conta 	= nr_interno_conta_p
  and       coalesce(cd_setor_receita,0)	<> cd_setor_atendimento;

if (ie_tipo_convenio_w = 3) and (ie_tipo_atendimento_w = 1) then
	BEGIN
	begin
	select a.cd_setor_atendimento
	into STRICT 	cd_setor_internacao_w
	from 	paciente_internado_v2 a
	where a.nr_atendimento = nr_atendimento_w
	  and a.cd_classif_setor = 3
	  and a.nr_seq_atepacu = obter_atepacu_paciente(a.nr_atendimento, 'IA')
	  and a.dt_entrada_unidade = (SELECT max(b.dt_entrada_unidade)
						from paciente_internado_v2 b
						where b.nr_atendimento = a.nr_atendimento
						  and b.cd_classif_setor = 3
						  and b.nr_seq_atepacu = obter_atepacu_paciente(b.nr_atendimento, 'IA'));
	exception
		when others then
		cd_setor_internacao_w := 0;
	end;
	if (cd_setor_internacao_w <> 0) then
		begin
		update	material_atend_paciente a
		set 		a.cd_setor_receita = cd_setor_internacao_w
		where 	a.nr_interno_conta = nr_interno_conta_p
		  and 	exists (
			SELECT 1
			from 	setor_atendimento y
			where y.cd_setor_atendimento = a.cd_setor_atendimento
			  and y.cd_classif_setor = 3);

		update 	procedimento_paciente a
		set 		a.cd_setor_receita = cd_setor_internacao_w
		where 	a.nr_interno_conta = nr_interno_conta_p
		  and 	exists (
			SELECT 1
			from 	setor_atendimento y
			where y.cd_setor_atendimento = a.cd_setor_atendimento
			  and y.cd_classif_setor = 3);
		end;
	end if;
	END;
	end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_setor_receita (nr_interno_conta_p bigint) FROM PUBLIC;

