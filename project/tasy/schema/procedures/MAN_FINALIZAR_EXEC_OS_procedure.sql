-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_finalizar_exec_os ( nr_seq_ordem_p bigint, nr_seq_exec_p bigint, nm_usuario_p text) AS $body$
DECLARE

possui_registros_w	varchar(1);


BEGIN

select  CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
into STRICT	possui_registros_w
from    man_ordem_servico_exec a
where   coalesce(a.dt_fim_execucao::text, '') = ''
and     a.nr_seq_ordem = nr_seq_ordem_p
and     a.nr_sequencia <> nr_seq_exec_p;

if (possui_registros_w = 'N') then
	-- Ao menos um executor do deve continuar ativo na OS, verifique.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(224512);
end if;

CALL MAN_ALTERAR_DATA_FIM_EXECUCAO(nr_seq_exec_p, clock_timestamp(), 'F', nm_usuario_p);

CALL MAN_EXCLUIR_ATIV_PREV_EXECUT(nr_seq_ordem_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_finalizar_exec_os ( nr_seq_ordem_p bigint, nr_seq_exec_p bigint, nm_usuario_p text) FROM PUBLIC;

