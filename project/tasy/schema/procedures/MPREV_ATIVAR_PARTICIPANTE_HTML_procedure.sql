-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_ativar_participante_html (nr_seq_participante_p bigint) AS $body$
DECLARE


ie_situacao_w	varchar(1);
ie_ativacao_w	varchar(3);


BEGIN

if (nr_seq_participante_p IS NOT NULL AND nr_seq_participante_p::text <> '') then
	begin

	select 	ie_situacao,
		mprev_verificar_ativacao(nr_sequencia)
	into STRICT	ie_situacao_w,
		ie_ativacao_w
	from	mprev_participante
	where	nr_sequencia = nr_seq_participante_p;

	if (ie_situacao_w <> 'A') then
		if (ie_ativacao_w <> 'NA') then
			if (ie_ativacao_w = 'DT') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(397069);
			elsif (ie_ativacao_w = 'NR') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(397083);
			else
				CALL mprev_ativar_participante(nr_seq_participante_p);
			end if;
		end if;
	end if;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_ativar_participante_html (nr_seq_participante_p bigint) FROM PUBLIC;
