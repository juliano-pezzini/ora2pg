-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_cancelamento_servico ( cd_usuario_p text, nr_sequencia_p bigint, nr_seq_motivo_cancelamento_p bigint, ie_status_p text) AS $body$
DECLARE


ie_acao_w sl_historico_acao.ie_acao%type := 'E';


BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	if (ie_status_p = 'C') then
		begin
		update	sl_unid_atend
		set	dt_cancelamento_servico = clock_timestamp(),
			cd_executor_canc_serv = cd_usuario_p,
			nr_seq_motivo_cancelamento = nr_seq_motivo_cancelamento_p,
			ie_status_serv = ie_status_p,
			nm_usuario = obter_usuario_ativo
		where	nr_sequencia = nr_sequencia_p;
		
		ie_acao_w := 'C';
		
		end;
	elsif (ie_status_p = 'P') then
		begin
		update	sl_unid_atend
		set	dt_cancelamento_servico  = NULL,
			cd_executor_canc_serv  = NULL,
			nr_seq_motivo_cancelamento  = NULL,
			ie_status_serv = ie_status_p,
			nm_usuario = obter_usuario_ativo
		where	nr_sequencia = nr_sequencia_p;	
		end;
	end if;
	
	if (ie_status_p in ('C','P')) then
		CALL inserir_hist_gestao_servico(ie_acao_w, nr_sequencia_p, wheb_usuario_pck.get_nm_usuario);
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_cancelamento_servico ( cd_usuario_p text, nr_sequencia_p bigint, nr_seq_motivo_cancelamento_p bigint, ie_status_p text) FROM PUBLIC;
