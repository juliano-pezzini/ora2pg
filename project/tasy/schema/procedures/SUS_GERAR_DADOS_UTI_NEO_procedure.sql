-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_dados_uti_neo ( nr_interno_conta_p bigint, nr_meses_gestacional_p bigint, nr_peso_p bigint, ie_motivo_saida_neo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
					
c01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	procedimento_paciente a
	where	a.nr_interno_conta = nr_interno_conta_p
	and	sus_validar_regra(7,a.cd_procedimento,a.ie_origem_proced,a.dt_procedimento) > 0
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	not exists (	SELECT	1
				from	sus_aih_uti_neo b
				where	b.nr_seq_procedimento = a.nr_sequencia);
					

BEGIN

open c01;
loop
fetch c01 into	
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	insert into sus_aih_uti_neo(
		nr_sequencia,
		nr_seq_procedimento,
		nr_meses_gestacional,
		nr_peso,
		ie_motivo_saida_neo,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec)
	values (	nextval('sus_aih_uti_neo_seq'),
		nr_sequencia_w,
		coalesce(nr_meses_gestacional_p,0),
		coalesce(nr_peso_p,0),
		coalesce(ie_motivo_saida_neo_p,0),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p);
	
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_dados_uti_neo ( nr_interno_conta_p bigint, nr_meses_gestacional_p bigint, nr_peso_p bigint, ie_motivo_saida_neo_p bigint, nm_usuario_p text) FROM PUBLIC;
