-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_bomba_interface ( nr_sequencia_interface_p bomba_infusao.nr_seq_bomba_interface%type, nr_seq_equipamento_p bomba_infusao.nr_seq_equipamento%type, ie_status_p bomba_infusao.ie_status%type, ie_ativo_p bomba_infusao.ie_ativo%type, nm_usuario_p bomba_infusao.nm_usuario%type, nr_prescricao_p bomba_infusao.nr_prescricao%type, dt_bomba_infusao_p bomba_infusao.dt_bomba_infusao%type default null, nr_seq_transicao_p bomba_infusao_transicao.nr_sequencia%type default 999999999, nr_atendimento_p bomba_infusao.nr_atendimento%type DEFAULT NULL, nr_seq_mat_cpoe_p bomba_infusao.nr_seq_mat_cpoe%type DEFAULT NULL, nr_seq_equipamento_channel_p bomba_infusao.nr_seq_canal_bomba%type default null, nr_seq_solucao_p bomba_infusao.nr_seq_solucao%type default null, nr_seq_agente_p bomba_infusao.nr_seq_agente%type default null) AS $body$
DECLARE


qt_volume_inicial_w			bomba_infusao_interface.qt_volume_inicial%type;
ie_pump_current_status_w		bomba_infusao.ie_ativo%type;
ds_retorno_integracao_w			varchar(4000);
bomba_infusao_seq_w			bigint;


BEGIN
    if ( coalesce(nr_seq_equipamento_p, 0) > 0 ) then
        select
            case when count(1) > 0 then 'S' else 'N' end qtd
        into STRICT ie_pump_current_status_w
        from
            bomba_infusao
        where
            bomba_infusao.nr_seq_equipamento = nr_seq_equipamento_p
            and coalesce(bomba_infusao.nr_seq_canal_bomba, 0) = coalesce(nr_seq_equipamento_channel_p, 0)
            and ie_ativo = 'S';

        if ( ie_pump_current_status_w = 'N' ) then
            select nextval('bomba_infusao_seq') 
              into STRICT bomba_infusao_seq_w
;

            insert into bomba_infusao(
                nr_sequencia,
                nr_seq_equipamento,
                ie_status,
                ie_ativo,
                dt_bomba_infusao,
                nm_usuario,
                nr_prescricao,
                nr_atendimento,
                dt_atualizacao,
                nr_seq_solucao,
                nr_seq_canal_bomba,
                nr_seq_mat_cpoe,
                nr_seq_agente,
                nr_seq_bomba_interface
            ) values (
                bomba_infusao_seq_w,
                nr_seq_equipamento_p,
                ie_status_p,
                ie_ativo_p,
                dt_bomba_infusao_p,
                nm_usuario_p,
                nr_prescricao_p,
                nr_atendimento_p,
                trunc(clock_timestamp()),
                nr_seq_solucao_p,
                (nr_seq_equipamento_channel_p)::numeric ,
                nr_seq_mat_cpoe_p,
                nr_seq_agente_p,
                nr_sequencia_interface_p
            );

            select get_volume_inicial_transicao(nr_sequencia_interface_p, nr_seq_transicao_p) 
            into STRICT qt_volume_inicial_w 
;
			
			update bomba_infusao_transicao
			   set	nr_Seq_bomba_infusao = bomba_infusao_seq_w
			 where nr_seq_bomba_interface = nr_sequencia_interface_p
			   and dt_transicao >= dt_bomba_infusao_p;			

            update bomba_infusao_interface
               set
                ie_em_uso = 'S', 
                qt_ult_volume = 0,
                qt_bolus = 0,
                qt_volume_inicial = qt_volume_inicial_w
            where nr_sequencia = nr_sequencia_interface_p;

            CALL registrar_mudanca_equip_bomba(nr_sequencia_interface_p,
                                          bomba_infusao_seq_w,
                                          1, --ie_alteracao_p
                                          nr_seq_agente_p);

            if ( coalesce(nr_seq_agente_p::text, '') = '' ) then
		  ds_retorno_integracao_w := infusion_pump_solution(bomba_infusao_seq_w, 1, ds_retorno_integracao_w, null);

		  if (ds_retorno_integracao_w IS NOT NULL AND ds_retorno_integracao_w::text <> '') then
			  CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_retorno_integracao_w);
		  end if;
            end if;

        else
            CALL wheb_mensagem_pck.exibir_mensagem_abort(1119224);
        end if;
    end if;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_bomba_interface ( nr_sequencia_interface_p bomba_infusao.nr_seq_bomba_interface%type, nr_seq_equipamento_p bomba_infusao.nr_seq_equipamento%type, ie_status_p bomba_infusao.ie_status%type, ie_ativo_p bomba_infusao.ie_ativo%type, nm_usuario_p bomba_infusao.nm_usuario%type, nr_prescricao_p bomba_infusao.nr_prescricao%type, dt_bomba_infusao_p bomba_infusao.dt_bomba_infusao%type default null, nr_seq_transicao_p bomba_infusao_transicao.nr_sequencia%type default 999999999, nr_atendimento_p bomba_infusao.nr_atendimento%type DEFAULT NULL, nr_seq_mat_cpoe_p bomba_infusao.nr_seq_mat_cpoe%type DEFAULT NULL, nr_seq_equipamento_channel_p bomba_infusao.nr_seq_canal_bomba%type default null, nr_seq_solucao_p bomba_infusao.nr_seq_solucao%type default null, nr_seq_agente_p bomba_infusao.nr_seq_agente%type default null) FROM PUBLIC;
