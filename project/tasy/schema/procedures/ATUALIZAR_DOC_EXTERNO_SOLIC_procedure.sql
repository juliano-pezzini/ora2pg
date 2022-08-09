-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_doc_externo_solic () AS $body$
DECLARE


nr_solic_compra_w			solic_compra.nr_solic_compra%type;
nr_documento_externo_w		solic_compra.nr_documento_externo%type;

c01 CURSOR FOR
SELECT	nr_solic_compra,
		nr_documento_externo
from	solic_compra
where	(nr_documento_externo IS NOT NULL AND nr_documento_externo::text <> '')
and 	(nr_solic_importacao IS NOT NULL AND nr_solic_importacao::text <> '')
and		coalesce(nr_doc_externo_receb::text, '') = '';


BEGIN

open c01;
loop
fetch c01 into
	nr_solic_compra_w,
	nr_documento_externo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	update	solic_compra
	set		nr_doc_externo_receb = nr_documento_externo,
			nr_documento_externo  = NULL
	where	nr_solic_compra = nr_solic_compra_w;

	insert into solic_compra_hist(
		nr_sequencia,
		nr_solic_compra,
		dt_atualizacao,
		nm_usuario,
		dt_historico,
		ds_titulo,
		ds_historico,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_tipo,
		cd_evento,
		dt_liberacao)
	values (
		nextval('solic_compra_hist_seq'),
		nr_solic_compra_w,
		clock_timestamp(),
		coalesce(wheb_usuario_pck.get_nm_usuario,'Sistema'),
		clock_timestamp(),
		wheb_mensagem_pck.get_texto(998486),
		wheb_mensagem_pck.get_texto(998486) || ': atualizar_doc_externo_solic',
		clock_timestamp(),
		coalesce(wheb_usuario_pck.get_nm_usuario,'Sistema'),
		'S',
		'DEX',
		clock_timestamp());

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_doc_externo_solic () FROM PUBLIC;
