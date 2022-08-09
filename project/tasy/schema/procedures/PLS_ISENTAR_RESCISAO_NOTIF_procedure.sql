-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_isentar_rescisao_notif ( nr_seq_notificacao_p bigint, nr_seq_motivo_isencao_p text, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Isentar o pagador de rescisão
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
	I = Realizar isenção
	D = Desfazer isenção
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN
if (ie_opcao_p = 'I') then
	update	pls_notificacao_pagador
	set	ie_rescisao		= 'N',
		nm_usuario_isencao	= nm_usuario_p,
		dt_isencao		= clock_timestamp(),
		nr_seq_motivo_isencao	= nr_seq_motivo_isencao_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_notificacao_p;
elsif (ie_opcao_p = 'D') then
	update	pls_notificacao_pagador
	set	ie_rescisao		= 'S',
		nm_usuario_isencao	 = NULL,
		dt_isencao		 = NULL,
		nr_seq_motivo_isencao	 = NULL,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_notificacao_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_isentar_rescisao_notif ( nr_seq_notificacao_p bigint, nr_seq_motivo_isencao_p text, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
