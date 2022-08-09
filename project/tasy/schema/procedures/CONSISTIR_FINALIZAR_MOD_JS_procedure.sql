-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_finalizar_mod_js ( nr_seq_modelo_p text, nr_seq_motivo_p text, ie_opcao_p text, nr_sequencia_p text, nr_seq_pac_modelo_p text, nm_usuario_p text, dt_fim_tratamento_p timestamp) AS $body$
DECLARE


ie_alerta_w	varchar(10);


BEGIN

if (nr_seq_motivo_p IS NOT NULL AND nr_seq_motivo_p::text <> '')then
	begin

	CALL rp_finalizar_modelo_agend(nr_seq_modelo_p, nr_seq_motivo_p, nm_usuario_p, ie_opcao_p, dt_fim_tratamento_p);

	ie_alerta_w	:= rp_alerta_finalizacao(nr_seq_pac_modelo_p, nr_sequencia_p);

	if (ie_alerta_w = 'S')then
		begin

		CALL Wheb_mensagem_pck.exibir_mensagem_abort(279984);

		end;
	end if;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_finalizar_mod_js ( nr_seq_modelo_p text, nr_seq_motivo_p text, ie_opcao_p text, nr_sequencia_p text, nr_seq_pac_modelo_p text, nm_usuario_p text, dt_fim_tratamento_p timestamp) FROM PUBLIC;
