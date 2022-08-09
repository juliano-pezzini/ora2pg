-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE avanca_retrocede_est_status (nr_prescricao_p bigint, nr_seq_prescricao_p bigint, ie_opcao_p text, nm_usuario_p text, ie_status_execucao_p text default null) AS $body$
DECLARE


nr_regra_atual_w STATUS_REGRA_ENTREGA.NR_SEQ_REGRA%TYPE;
nr_status_atual_w ESTAGIO_STATUS_ENTREGA.NR_SEQ_STATUS%TYPE;
nr_status_proximo_w ESTAGIO_STATUS_ENTREGA.NR_SEQ_STATUS%TYPE;
nr_seq_estagio_atual_w ESTAGIO_STATUS_ENTREGA.NR_SEQUENCIA%TYPE;
nr_seq_estagio_proximo_w ESTAGIO_STATUS_ENTREGA.NR_SEQUENCIA%TYPE;
nr_seq_prescr_proc_compl_w PRESCR_PROCEDIMENTO_COMPL.NR_SEQUENCIA%TYPE;
ie_status_execucao_w STATUS_REGRA_ENTREGA.IE_STATUS_EXECUCAO%TYPE;
nr_sequencia_aux_w bigint;



BEGIN

select prescr_proc.nr_seq_proc_compl,
	   prescr_proc_compl.nr_seq_estagio_entrega
into STRICT nr_seq_prescr_proc_compl_w,
	 nr_seq_estagio_atual_w
from prescr_procedimento prescr_proc
     left join prescr_procedimento_compl prescr_proc_compl ON (prescr_proc.nr_seq_proc_compl = prescr_proc_compl.nr_sequencia)
where prescr_proc.nr_prescricao = nr_prescricao_p
and   prescr_proc.nr_sequencia = nr_seq_prescricao_p;

select nr_seq_status
into STRICT nr_status_atual_w
from ESTAGIO_STATUS_ENTREGA
where nr_sequencia = nr_seq_estagio_atual_w;

select ie_status_execucao,
	   nr_seq_regra
into STRICT ie_status_execucao_w,
     nr_regra_atual_w
from status_regra_entrega
where nr_sequencia = nr_status_atual_w;

if (ie_opcao_p = 'A') then

	if (ie_status_execucao_p IS NOT NULL AND ie_status_execucao_p::text <> '') then
		select NR_SEQUENCIA
		into STRICT nr_status_proximo_w
		from (SELECT nr_sequencia
				from STATUS_REGRA_ENTREGA
				where nr_seq_regra = nr_regra_atual_w
				and   ie_status_execucao = ie_status_execucao_p
				order by ie_status_execucao asc) alias2 LIMIT 1;
	else
		select NR_SEQUENCIA
		into STRICT nr_status_proximo_w
		from (SELECT nr_sequencia
				from STATUS_REGRA_ENTREGA
				where nr_seq_regra = nr_regra_atual_w
				and   ie_status_execucao > ie_status_execucao_w
				order by ie_status_execucao asc) alias0 LIMIT 1;
	end if;

	select nr_sequencia
	into STRICT nr_seq_estagio_proximo_w
	from (SELECT nr_sequencia
		  from estagio_status_entrega
		  where nr_seq_status = nr_status_proximo_w
		  order by nr_sequencia) alias0 LIMIT 1;

elsif (ie_opcao_p = 'R') then

	if (ie_status_execucao_p IS NOT NULL AND ie_status_execucao_p::text <> '') then
		select NR_SEQUENCIA
		into STRICT nr_status_proximo_w
		from (SELECT nr_sequencia
				from STATUS_REGRA_ENTREGA
				where nr_seq_regra = nr_regra_atual_w
				and   ie_status_execucao = ie_status_execucao_p
				order by ie_status_execucao desc) alias2 LIMIT 1;
	else
     	select NR_SEQUENCIA
		into STRICT nr_status_proximo_w
		from (SELECT nr_sequencia
				from STATUS_REGRA_ENTREGA
				where nr_seq_regra = nr_regra_atual_w
				and   ie_status_execucao < ie_status_execucao_w
				order by ie_status_execucao desc) alias0 LIMIT 1;
	end if;


	select nr_sequencia
	into STRICT nr_seq_estagio_proximo_w
	from (SELECT nr_sequencia
		  from estagio_status_entrega
		  where nr_seq_status = nr_status_proximo_w
		  order by nr_sequencia desc) alias0 LIMIT 1;

end if;

if (nr_seq_estagio_proximo_w IS NOT NULL AND nr_seq_estagio_proximo_w::text <> '') then

	update prescr_procedimento_compl
	set nr_seq_estagio_entrega = nr_seq_estagio_proximo_w,
	    nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where nr_sequencia = nr_seq_prescr_proc_compl_w;

	CALL gravar_auditoria_entrega(nr_seq_estagio_proximo_w,
						 nr_prescricao_p,
						 nr_seq_prescricao_p,
						 nm_usuario_p);


end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE avanca_retrocede_est_status (nr_prescricao_p bigint, nr_seq_prescricao_p bigint, ie_opcao_p text, nm_usuario_p text, ie_status_execucao_p text default null) FROM PUBLIC;
