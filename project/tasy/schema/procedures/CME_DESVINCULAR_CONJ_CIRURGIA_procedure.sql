-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_desvincular_conj_cirurgia ( cd_barras_p bigint, nr_cirurgia_p bigint, nm_usuario_p text, nr_seq_pepo_p bigint) AS $body$
DECLARE

 
nm_paciente_w		varchar(100);	
nr_atendimento_w		bigint;
ds_observacao_w		varchar(255);
nr_cirurgia_w		bigint;
nr_prescricao_w		bigint;
nr_seq_pepo_w		bigint;
dt_liberacao_w		timestamp;
ie_fim_conta_w		varchar(1);
ie_forma_lancamento_w	varchar(15);
nr_seq_regra_pepo_w	bigint;
dt_entrada_unidade_w	timestamp;


BEGIN 
 
 
begin 
select	max(substr(obter_nome_pf(cd_pessoa_fisica),1,100)), 
	max(nr_atendimento), 
	max(dt_entrada_unidade), 
	max(nr_prescricao) 
into STRICT	nm_paciente_w, 
	nr_atendimento_w, 
	dt_entrada_unidade_w, 
	nr_prescricao_w 
from	cirurgia 
where	coalesce(nr_cirurgia,0) = coalesce(nr_cirurgia_p,0) 
and	coalesce(nr_seq_pepo,0) = coalesce(nr_seq_pepo_p,0);
exception 
	when others then 
		-- Cirurgia não encontrada! 
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(264838);
end;
 
 
ds_observacao_w	:= WHEB_MENSAGEM_PCK.get_texto(300051,'NM_PACIENTE_W='|| NM_PACIENTE_W ||';NR_ATENDIMENTO_W='|| NR_ATENDIMENTO_W);
/*Paciente: #@NM_PACIENTE_W#@ Nº Atendimento: #@NR_ATENDIMENTO_W#@.*/
 
 
 
 
begin 
 
select	nr_cirurgia, 
	nr_seq_pepo, 
	dt_liberacao, 
	nr_seq_regra_pepo 
into STRICT	nr_cirurgia_w, 
	nr_seq_pepo_w, 
	dt_liberacao_w, 
	nr_seq_regra_pepo_w 
from	cm_conjunto_cont 
where	nr_sequencia	= cd_barras_p 
and	coalesce(ie_situacao,'A') = 'A';
exception 
	when others then 
		-- Conjunto não encontrado! 
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(153617);
end;
 
if (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') then 
	-- Este conjunto está liberado e não poderá ser desvinculado! 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264839);
end if;	
 
if	((nr_cirurgia_w IS NOT NULL AND nr_cirurgia_w::text <> '') or (nr_seq_pepo_w IS NOT NULL AND nr_seq_pepo_w::text <> '')) then 
	CALL vinc_desv_item_controle_cme(nr_cirurgia_w,nr_seq_pepo_w,cd_barras_p,'D',nm_usuario_p);
	update	cm_conjunto_cont 
	set	nr_cirurgia			 = NULL, 
		ds_observacao			 = NULL, 
		dt_atualizacao			= clock_timestamp(), 
		nm_usuario			= nm_usuario_p, 
		nr_atendimento			 = NULL, 
		nr_seq_pepo			 = NULL, 
		nr_seq_regra_pepo		 = NULL, 
		dt_lancamento_automatico 	 = NULL 
	where	nr_sequencia			= cd_barras_p;
	 
	select	max(ie_forma_lancamento) 
	into STRICT	ie_forma_lancamento_w 
	from	regra_lancamento_pepo 
	where	nr_sequencia = nr_seq_regra_pepo_w;
	 
	if (ie_forma_lancamento_w in ('C','CE')) then 
		select	ie_fim_conta 
		into STRICT	ie_fim_conta_w 
		from	atendimento_paciente 
		where	nr_atendimento = nr_atendimento_w;
		 
		if (ie_fim_conta_w = 'F') then 
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(275109);
		else	 
			delete	 
			from	material_atend_paciente 
			where 	nr_seq_regra_pepo 	= nr_seq_regra_pepo_w 
			and 	nr_atendimento 		= nr_atendimento_w 
			and 	dt_entrada_unidade 	= dt_entrada_unidade_w;
			 
			delete 
			from 	procedimento_paciente 
			where 	nr_seq_regra_pepo 	= nr_seq_regra_pepo_w 
			and 	nr_atendimento 		= nr_atendimento_w 
			and 	dt_entrada_unidade 	= dt_entrada_unidade_w;
		end if;	
	elsif (ie_forma_lancamento_w = 'P') then 
		delete	 
		from 	prescr_material 
		where 	nr_seq_regra_pepo 	= nr_seq_regra_pepo_w 
		and 	coalesce(cd_motivo_baixa,0) 	= 0 
		and	nr_prescricao		= nr_prescricao_w;
		 
		delete 	 
		from	prescr_procedimento 
		where 	nr_seq_regra_pepo 	= nr_seq_regra_pepo_w 
		and 	coalesce(cd_motivo_baixa,0) 	= 0 
		and	nr_prescricao		= nr_prescricao_w;
	end if;	
	 
	commit;
else 
	-- Este conjunto não pertence a cirurgia. 
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264840);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_desvincular_conj_cirurgia ( cd_barras_p bigint, nr_cirurgia_p bigint, nm_usuario_p text, nr_seq_pepo_p bigint) FROM PUBLIC;

