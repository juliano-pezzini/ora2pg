-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_alterar_sit_partic ( nr_seq_participante_p bigint, ie_nova_situacao_p text, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Inativar participante
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: HDM - Controle de Participantes
[  ]  Objetos do dicionario [ x ] Tasy (Delphi/Java) [ ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_situacao_w		mprev_participante.ie_situacao%type;
nr_seq_participante_w	mprev_participante.nr_sequencia%type;

c01 CURSOR FOR
	SELECT	ie_situacao
	from 	mprev_participante
	where 	nr_sequencia = nr_seq_participante_p;

BEGIN
if (nr_seq_participante_p IS NOT NULL AND nr_seq_participante_p::text <> '') then
	open c01;
	loop
	fetch c01 into
		ie_situacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (ie_situacao_w <> 'I')	then
			update	mprev_participante
			set	ie_situacao 		= ie_nova_situacao_p,
				nm_usuario		= nm_usuario_p,
				dt_atualizacao	= clock_timestamp()
			where	nr_sequencia 		= nr_seq_participante_p;
		end if;
		end;
	end loop;					
	close c01;
	if (coalesce(ie_commit_p,'S') = 'S') then
		commit;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_alterar_sit_partic ( nr_seq_participante_p bigint, ie_nova_situacao_p text, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;

