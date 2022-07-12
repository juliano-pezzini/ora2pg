-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE integracao_dispensario_pck.esteira_enviar_lote_prescr ( nr_prescricao_p bigint, nr_seq_item_p bigint, nr_seq_horario_p bigint, nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE

	
	current_setting('integracao_dispensario_pck.nr_seq_lote_w')::ap_lote.nr_sequencia%type					ap_lote.nr_sequencia%type;
	nr_seq_lote_ant_w				ap_lote.nr_sequencia%type := 0;
	reg_integracao_p				gerar_int_padrao.reg_integracao;
	cd_local_estoque_w				local_estoque.cd_local_estoque%type;
	current_setting('integracao_dispensario_pck.cd_setor_atendimento_w')::setor_atendimento.cd_setor_atendimento%type			setor_atendimento.cd_setor_atendimento%type;
	
	C07 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.cd_local_estoque,
		a.cd_setor_atendimento
	from	ap_lote a,
		prescr_mat_hor b
	where	a.nr_prescricao = b.nr_prescricao
	and	a.nr_prescricao = nr_prescricao_p
	and	b.nr_seq_material = nr_seq_item_p
	and	a.nr_sequencia in (
				SELECT	c.nr_seq_lote
				from	ap_lote_item c
				where	c.nr_seq_lote = a.nr_sequencia
				and	c.nr_seq_mat_hor = nr_seq_horario_p)
	and	coalesce(b.dt_suspensao::text, '') = ''
	and	a.ie_status_lote = 'G'
	and	Obter_se_horario_liberado(b.dt_lib_horario, b.dt_horario) = 'S'
	order by 1;

	
BEGIN
	
	open C07;
	loop
	fetch C07 into	
		current_setting('integracao_dispensario_pck.nr_seq_lote_w')::ap_lote.nr_sequencia%type,
		cd_local_estoque_w,
		current_setting('integracao_dispensario_pck.cd_setor_atendimento_w')::setor_atendimento.cd_setor_atendimento%type;
	EXIT WHEN NOT FOUND; /* apply on C07 */
		begin
		if (current_setting('integracao_dispensario_pck.nr_seq_lote_w')::ap_lote.nr_sequencia%type <> nr_seq_lote_ant_w) then
			reg_integracao_p.cd_estab_documento	:= wheb_usuario_pck.get_cd_estabelecimento;
			reg_integracao_p.cd_local_estoque	:= cd_local_estoque_w;
			reg_integracao_p.nr_seq_agrupador	:= current_setting('integracao_dispensario_pck.nr_seq_lote_w')::ap_lote.nr_sequencia%type;
			reg_integracao_p.cd_setor_atendimento	:= current_setting('integracao_dispensario_pck.cd_setor_atendimento_w')::setor_atendimento.cd_setor_atendimento%type;
			reg_integracao_p := gerar_int_padrao.gravar_integracao('260', current_setting('integracao_dispensario_pck.nr_seq_lote_w')::ap_lote.nr_sequencia%type, nm_usuario_p, reg_integracao_p);
		end if;	
		nr_seq_lote_ant_w := current_setting('integracao_dispensario_pck.nr_seq_lote_w')::ap_lote.nr_sequencia%type;
		end;
	end loop;
	close C07;
	
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integracao_dispensario_pck.esteira_enviar_lote_prescr ( nr_prescricao_p bigint, nr_seq_item_p bigint, nr_seq_horario_p bigint, nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
