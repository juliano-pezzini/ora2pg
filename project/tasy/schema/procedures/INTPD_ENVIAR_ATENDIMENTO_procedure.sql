-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_enviar_atendimento ( nr_atendimento_p text, ie_operacao_p text, ie_controle_tag_p bigint, nm_usuario_p text) AS $body$
DECLARE


reg_integracao_w	gerar_int_padrao.reg_integracao;
qt_registros_w		bigint;


BEGIN

/*Esse count foi feito porque quando altera ou inclui algum registro na tabela ATEND_PACIENTE_UNIDADE,
o sistema manda para a integração, e faz update na ATENDIMENTO_PACIENTE. E com isso, acaba mandando de novo para a fila, gerando dois registros. */
select	count(*)
into STRICT	qt_registros_w
from	intpd_fila_transmissao
where	ie_evento = '214'
and	nr_seq_documento = nr_atendimento_p
and	ie_status in ('P','R')
and	ie_operacao = ie_operacao_p
and ie_controle_tag = to_char(ie_controle_tag_p);

if (qt_registros_w = 0) and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	begin
	reg_integracao_w.cd_estab_documento		:= wheb_usuario_pck.get_cd_estabelecimento;
	reg_integracao_w.ie_operacao			:= ie_operacao_p;
	reg_integracao_w.ie_controle_tag		:= ie_controle_tag_p;

	reg_integracao_w := gerar_int_padrao.gravar_integracao('214', nr_atendimento_p, nm_usuario_p, reg_integracao_w);
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_enviar_atendimento ( nr_atendimento_p text, ie_operacao_p text, ie_controle_tag_p bigint, nm_usuario_p text) FROM PUBLIC;
