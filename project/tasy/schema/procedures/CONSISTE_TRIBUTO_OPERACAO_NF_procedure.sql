-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_tributo_operacao_nf ( nr_sequencia_p bigint, cd_operacao_nf_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


ds_tributo_w			varchar(255);
ie_corpo_item_w			varchar(1);
cd_tributo_w			smallint;
qt_existe_w			bigint;

c01 CURSOR FOR
SELECT	cd_tributo
from	operacao_nota_trib
where	cd_operacao_nf = cd_operacao_nf_p
and	((cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento) or (coalesce(cd_estabelecimento::text, '') = ''));


BEGIN

open c01;
loop
fetch c01 into
	cd_tributo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	coalesce(max(ie_corpo_item),'C'),
		max(ds_tributo)
	into STRICT	ie_corpo_item_w,
		ds_tributo_w
	from	tributo
	where	cd_tributo = cd_tributo_w;

	if (ie_corpo_item_w = 'V') then

		select	count(*)
		into STRICT	qt_existe_w
		from	nota_fiscal_venc_trib
		where	nr_sequencia = nr_sequencia_p
		and	cd_tributo = cd_tributo_w;

	elsif (ie_corpo_item_w = 'I') then

		select	count(*)
		into STRICT	qt_existe_w
		from	nota_fiscal_item_trib
		where	nr_sequencia = nr_sequencia_p
		and	cd_tributo = cd_tributo_w;

	else

		select	count(*)
		into STRICT	qt_existe_w
		from	nota_fiscal_trib
		where	nr_sequencia = nr_sequencia_p
		and	cd_tributo = cd_tributo_w;

	end if;

	if (qt_existe_w = 0) then

		ds_erro_p	:= substr(WHEB_MENSAGEM_PCK.get_texto(281433) || ' ' || ds_tributo_w || ' ' || WHEB_MENSAGEM_PCK.get_texto(281434),1,255);

		CALL gravar_nota_fiscal_consist(
			nr_sequencia_p,
			WHEB_MENSAGEM_PCK.get_texto(281433) || ' ' || ds_tributo_w || ' ' || WHEB_MENSAGEM_PCK.get_texto(281434),
			'S','N',
			WHEB_MENSAGEM_PCK.get_texto(281433) || ' ' || ds_tributo_w || ' ' || WHEB_MENSAGEM_PCK.get_texto(281436),
			nm_usuario_p,'S');

	end if;

	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_tributo_operacao_nf ( nr_sequencia_p bigint, cd_operacao_nf_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
