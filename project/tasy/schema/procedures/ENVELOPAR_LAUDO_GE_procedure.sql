-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE envelopar_laudo_ge ( nr_sequencia_p text, nm_usuario_p text) AS $body$
DECLARE


ds_erro_w	varchar(2000) := '';
ds_auxiliar_w	varchar(4000) := '';
nr_sequencia_w	varchar(4000) := '';
k integer;


BEGIN
--Utilizado na Gestão de exames Java
nr_sequencia_w := nr_sequencia_p;

while	(nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') loop
	begin

	select	position(',' in nr_sequencia_w)
	into STRICT	k
	;

	if (k > 1) and ((substr(nr_sequencia_w, 1, k -1) IS NOT NULL AND (substr(nr_sequencia_w, 1, k -1))::text <> '')) then
		ds_auxiliar_w	:= substr(nr_sequencia_w, 1, k-1);
		ds_auxiliar_w	:= replace(ds_auxiliar_w, ',','');
		nr_sequencia_w	:= substr(nr_sequencia_w, k + 1, 4000);
	elsif (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		ds_auxiliar_w	:= replace(nr_sequencia_w,',','');
		nr_sequencia_w	:= '';
	end if;

	ds_erro_w := Atualizar_laudo_envelopado(ds_auxiliar_w, nm_usuario_p, ds_erro_w);

	if (ds_erro_w <> '') then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(261436, 'ERRO='|| ds_erro_w);
	end if;

	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE envelopar_laudo_ge ( nr_sequencia_p text, nm_usuario_p text) FROM PUBLIC;

