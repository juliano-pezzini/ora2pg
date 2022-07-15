-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_regra_prot_proced ( nr_seq_paciente_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_perfil_w		bigint;
nr_seq_erro_w		bigint;
qt_procedimentos_w	bigint := 0;


BEGIN
cd_perfil_w	:= obter_perfil_ativo;

delete from paciente_atendimento_erro
where	nr_seq_paciente	= nr_seq_paciente_p
and		coalesce(nr_seq_material::text, '') = '';

if (obter_se_consistir_regra_onc(5, cd_perfil_w)	= 'S') then
begin

	select	count(nr_seq_procedimento)
	into STRICT	qt_procedimentos_w
	from	paciente_protocolo_proc
	where	nr_seq_paciente	= nr_seq_paciente_p;

	if (qt_procedimentos_w = 0) then
		nr_seq_erro_w := gerar_erro_pac_prot(nr_seq_paciente_p, null, 5, null, cd_perfil_w, nm_usuario_p, nr_seq_erro_w);
	end if;
end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_regra_prot_proced ( nr_seq_paciente_p bigint, nm_usuario_p text) FROM PUBLIC;

