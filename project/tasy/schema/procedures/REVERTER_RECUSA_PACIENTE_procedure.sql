-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reverter_recusa_paciente (nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_horario_p bigint, cd_item_p bigint, nm_usuario_p text, ie_tipo_item_p text, nr_seq_processo_p bigint default null) AS $body$
DECLARE

								
c01 CURSOR FOR
SELECT	a.nr_sequencia nr_seq_horario,
		a.cd_material,
		a.nr_prescricao,
		obter_se_acm_sn(b.ie_acm, b.ie_se_necessario) ie_acm_sn,
		a.nr_seq_material,
		a.dt_horario
from	prescr_mat_hor a,
		prescr_material b
where	a.nr_prescricao 	= b.nr_prescricao
and		a.nr_seq_material 	= b.nr_sequencia
and		coalesce(a.dt_fim_horario::text, '') = ''
and		a.nr_seq_processo	= nr_seq_processo_p
and		coalesce(nr_seq_processo_p,0) > 0

union

SELECT	a.nr_sequencia,
		a.cd_material,
		a.nr_prescricao,
		obter_se_acm_sn(b.ie_acm, b.ie_se_necessario) ie_acm_sn,
		a.nr_seq_material,
		a.dt_horario
from	prescr_mat_hor a,
		prescr_material b
where	a.nr_prescricao		= b.nr_prescricao
and		a.nr_seq_material 	= b.nr_sequencia
and		coalesce(a.dt_fim_horario::text, '') = ''
and		coalesce(nr_seq_processo_p,0) = 0
and		nr_seq_horario_p	> 0
and		a.nr_sequencia		= nr_seq_horario_p
and		coalesce(ie_tipo_item_p,'M') <> 'E'

union

select	c.nr_sequencia,
		cd_item_p,
		nr_prescricao_p,
		obter_se_acm_sn(b.ie_acm, b.ie_se_necessario) ie_acm_sn,
		null nr_seq_material,
		c.dt_horario
from	pe_prescr_proc_hor 	c,
		pe_prescr_proc 		b
where	b.nr_seq_prescr		= c.nr_seq_pe_prescr
and		b.nr_sequencia		= c.nr_seq_pe_proc
and		c.nr_sequencia 		= nr_seq_horario_p
and		coalesce(ie_tipo_item_p,'M') = 'E'
and		coalesce(nr_seq_processo_p,0) = 0
and		nr_seq_horario_p	> 0;

BEGIN

if	(nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '' AND nr_seq_horario_p IS NOT NULL AND nr_seq_horario_p::text <> '') or (coalesce(nr_seq_processo_p,0) > 0) then
	
	for c01_w in c01 loop
		begin
		if (coalesce(ie_tipo_item_p,'M') in ('IAH', 'M', 'S')) then
			update	prescr_mat_hor
			set		dt_recusa 		 = NULL,
					nm_usuario 		= nm_usuario_p,
					dt_atualizacao	= clock_timestamp()
			where	nr_sequencia	= c01_w.nr_seq_horario;
						
			insert into prescr_mat_alteracao(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_prescricao,
				dt_alteracao,
				cd_pessoa_fisica,
				ie_alteracao,
				ds_justificativa,
				ie_tipo_item,
				nr_atendimento,
				cd_item,
				nr_seq_horario,
				ds_observacao,
				nr_seq_prescricao,
				nr_seq_assinatura,
				nr_seq_motivo_susp,
				ie_acm_sn)
			values (
				nextval('prescr_mat_alteracao_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				c01_w.nr_prescricao,
				clock_timestamp(),
				substr(obter_dados_usuario_opcao(nm_usuario_p,'C'),1,10),
				62,
				wheb_mensagem_pck.get_texto(1062993), --'Reversão da recusa do item',
				coalesce(ie_tipo_item_p,'M'),
				nr_atendimento_p,
				c01_w.cd_material,
				c01_w.nr_seq_horario,
				'',
				c01_w.nr_seq_material,
				null,
				null,
				c01_w.ie_acm_sn);
								
			UPDATE	prescr_mat_alteracao
			SET	ie_evento_valido	= 'N'
			WHERE nr_prescricao 	= c01_w.nr_prescricao
			AND nr_seq_horario 		= c01_w.nr_seq_horario
			AND ie_alteracao 		= 38;
				
			update 	prescr_mat_hor
			set 	dt_recusa 		 = NULL,
					nm_usuario 		= nm_usuario_p,
					dt_atualizacao	= clock_timestamp()									
			where 	nr_seq_superior = c01_w.nr_seq_material
			and 	nr_prescricao 	= c01_w.nr_prescricao
			and 	dt_horario 		= c01_w.dt_horario
			and 	ie_agrupador 	in (2,3,7,9);
			
		elsif (coalesce(ie_tipo_item_p,'M') = 'E') then
			update	pe_prescr_proc_hor c
			set		dt_recusa 		 = NULL,
					nm_usuario 		= nm_usuario_p,
					dt_atualizacao	= clock_timestamp()
			where	c.nr_sequencia 	= c01_w.nr_seq_horario;
			
			insert into prescr_mat_alteracao(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_prescricao,
				dt_alteracao,
				cd_pessoa_fisica,
				ie_alteracao,
				ds_justificativa,
				ie_tipo_item,
				nr_atendimento,
				cd_item,
				ds_observacao,
				nr_seq_horario_sae,
				nr_seq_assinatura)
			values (
				nextval('prescr_mat_alteracao_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_prescricao_p,
				clock_timestamp(),
				obter_dados_usuario_opcao(nm_usuario_p,'C'),
				62,
				wheb_mensagem_pck.get_texto(1062993), --'Reversão da recusa do item',
				coalesce(ie_tipo_item_p,'M'),
				nr_atendimento_p,
				cd_item_p,
				null,
				c01_w.nr_seq_horario,
				null);				
				
			UPDATE	prescr_mat_alteracao
			SET	ie_evento_valido	= 'N'
			WHERE nr_prescricao 	= c01_w.nr_prescricao
			AND nr_seq_horario_sae 	= c01_w.nr_seq_horario
			AND ie_alteracao 		= 38;
			
		end if;
		end;
	end loop;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reverter_recusa_paciente (nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_horario_p bigint, cd_item_p bigint, nm_usuario_p text, ie_tipo_item_p text, nr_seq_processo_p bigint default null) FROM PUBLIC;

