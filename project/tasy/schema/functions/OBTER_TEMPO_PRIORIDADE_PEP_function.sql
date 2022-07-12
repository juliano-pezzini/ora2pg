-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_prioridade_pep (nr_prescricao_p bigint, nr_seq_proc_interno_p bigint, nr_seq_prescricao_p bigint, nr_seq_laudo_p bigint, ds_titulo_laudo_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_prioridade_w REG_PRIOR_PROCED_EXAME.nr_sequencia%type;
nr_prioridade_w PROTOCOLO_MEDIC_PROC.NR_SEQ_REG_PRIOR_PROCED_EXAME%type;
nr_tmp_execucao_w	smallint;
dt_prazo_execucao_w      timestamp;
dt_execucao_w      timestamp;
ds_tmp_para_execucao_w	varchar(255);


BEGIN

  nr_seq_prioridade_w := obter_prioridade_pep(nr_prescricao_p,nr_seq_prescricao_p,ds_titulo_laudo_p);

  select HTML_OBTER_DATAS_LAUDO_DATE(nr_prescricao_p, nr_seq_prescricao_p, nr_seq_laudo_p, 'DT_APROVACAO')
  into STRICT    dt_execucao_w
;

	if (nr_seq_prioridade_w IS NOT NULL AND nr_seq_prioridade_w::text <> '') then
		select max(rppe.nr_prioridade),
			max(rppe.NR_TEMPO_CIENCIA)
		into STRICT nr_prioridade_w,
			nr_tmp_execucao_w
		from reg_prior_proced_exame rppe
		where rppe.nr_sequencia = nr_seq_prioridade_w;		
			
		if (nr_tmp_execucao_w IS NOT NULL AND nr_tmp_execucao_w::text <> '') and (nr_tmp_execucao_w > 0) then

			select ADICIONAR_MINUTOS_DATA(obter_estabelecimento_ativo, dt_execucao_w, nr_tmp_execucao_w, 'COR')
			into STRICT dt_prazo_execucao_w
			;

			select obter_horas_min(dt_prazo_execucao_w, clock_timestamp())
			into STRICT ds_tmp_para_execucao_w
			;

			if (((clock_timestamp() - dt_prazo_execucao_w)*24*60) > nr_tmp_execucao_w)
				or (((clock_timestamp() - dt_prazo_execucao_w)*24*60) < 0) then
				ds_tmp_para_execucao_w := 0;
			end if;

		end if;
	end if;


return ds_tmp_para_execucao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_prioridade_pep (nr_prescricao_p bigint, nr_seq_proc_interno_p bigint, nr_seq_prescricao_p bigint, nr_seq_laudo_p bigint, ds_titulo_laudo_p text) FROM PUBLIC;
