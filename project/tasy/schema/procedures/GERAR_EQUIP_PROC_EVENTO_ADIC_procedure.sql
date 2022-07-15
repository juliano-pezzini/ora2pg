-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_equip_proc_evento_adic ( nr_seq_evento_p bigint, nr_atendimento_p bigint, nr_cirurgia_p bigint, nm_usuario_p text, dt_inicio_evento_p timestamp) AS $body$
DECLARE


nr_seq_quip_cir_w			equipamento_cirurgia.nr_sequencia%type;
ie_iniciar_equipamento_w	cirurgia_evento_adic_regra.ie_iniciar_equipamento%type;

evento_proc_adic CURSOR FOR
	SELECT pe.cd_equipamento
	from cirurgia_evento_adic_proc ap,
		 proc_interno pdi, 
		 procedimento prc, 
		 procedimento_equip pe
	where ap.nr_seq_regra_adic = nr_seq_evento_p
	and   ap.nr_seq_proc_interno = pdi.nr_sequencia
	and   obter_info_proc_tab_interno(ap.nr_seq_proc_interno, null, nr_atendimento_p, null, null, null, null, 'CD') = prc.cd_procedimento 
	and   obter_info_proc_tab_interno(ap.nr_seq_proc_interno, null, nr_atendimento_p, null, null, null, null, 'O')  = prc.ie_origem_proced
	and   prc.cd_procedimento = pe.cd_procedimento
	and   prc.ie_origem_proced = pe.ie_origem_proced;

BEGIN
	
	select	max(reg.ie_iniciar_equipamento)
	into STRICT	ie_iniciar_equipamento_w
	from	cirurgia_evento_adic_regra reg
	where	reg.nr_sequencia = nr_seq_evento_p
	and		reg.ie_iniciar_equipamento = 'S'
	and		reg.ie_situacao = 'A';

	for epa_w in evento_proc_adic loop
		begin
			select	nextval('equipamento_cirurgia_seq')
			into STRICT	nr_seq_quip_cir_w
			;
			
			insert into equipamento_cirurgia(
				nr_sequencia,
				nr_cirurgia,
				cd_equipamento,
				qt_equipamento,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_profissional,
				dt_inicio,
				ie_situacao)
			values (
				nr_seq_quip_cir_w,
				nr_cirurgia_p,
				epa_w.cd_equipamento,
				1,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				obter_pessoa_fisica_usuario(nm_usuario_p, 'C'),
				(CASE WHEN (ie_iniciar_equipamento_w IS NOT NULL AND ie_iniciar_equipamento_w::text <> '') THEN dt_inicio_evento_p ELSE null END),
				'A');
											
			commit;
		end;
	end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_equip_proc_evento_adic ( nr_seq_evento_p bigint, nr_atendimento_p bigint, nr_cirurgia_p bigint, nm_usuario_p text, dt_inicio_evento_p timestamp) FROM PUBLIC;

