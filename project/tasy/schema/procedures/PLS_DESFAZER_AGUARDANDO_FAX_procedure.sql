-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_aguardando_fax ( nr_seq_auditoria_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Alterar o status da análise alterando fax para análise
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_registros_w 				bigint;
nr_seq_guia_w				bigint;
nr_seq_requisicao_w			bigint;


BEGIN
select 	count(1)
into STRICT 	qt_registros_w
from	pls_auditoria
where	nr_sequencia	= nr_seq_auditoria_p
and	ie_status 	= 'AF';

if (qt_registros_w > 0) 	then
	begin
		select 	nr_seq_guia,
			nr_seq_requisicao
		into STRICT	nr_seq_guia_w,
			nr_seq_requisicao_w
		from	pls_auditoria
		where	nr_sequencia	= nr_seq_auditoria_p;
	exception
	when others then
		nr_seq_guia_w		:= Null;
		nr_seq_requisicao_w 	:= Null;
	end;

	update 	pls_auditoria
	set	ie_status 	= 'A',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia 	= nr_seq_auditoria_p;

	if (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then
		CALL pls_requisicao_gravar_hist(	nr_seq_requisicao_w, 'L', wheb_mensagem_pck.get_texto(779727, 'DS_USUARIO=' || nm_usuario_p || ';DT=' || to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss')),
			null, nm_usuario_p);

	elsif (nr_seq_guia_w IS NOT NULL AND nr_seq_guia_w::text <> '') then
		CALL pls_guia_gravar_historico(	nr_seq_guia_w, 2, wheb_mensagem_pck.get_texto(779727, 'DS_USUARIO=' || nm_usuario_p || ';DT=' || to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss')),
			'', nm_usuario_p);
	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_aguardando_fax ( nr_seq_auditoria_p bigint, nm_usuario_p text) FROM PUBLIC;
