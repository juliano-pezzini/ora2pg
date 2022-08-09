-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_hist_rep_integracao (nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


qt_registro_w	bigint;
ds_erro_w	varchar(4000);

dt_historico_w		timestamp;
ds_historico_w		w_repasse_terceiro_hist.ds_historico%type;
nr_repasse_terceiro_w	w_repasse_terceiro_hist.nr_repasse_terceiro%type;

c01 CURSOR FOR
SELECT	a.dt_historico,
	a.ds_historico,
	a.nr_repasse_terceiro
from	w_repasse_terceiro_hist a
where (a.nm_usuario = nm_usuario_p or coalesce(nm_usuario_p::text, '') = '');


BEGIN

ds_erro_w	:= null;

open	c01;
loop
fetch	c01 into
	dt_historico_w,
	ds_historico_w,
	nr_repasse_terceiro_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	count(*)
	into STRICT	qt_registro_w
	from	repasse_terceiro a
	where	a.nr_repasse_terceiro	= nr_repasse_terceiro_w;

	if (coalesce(qt_registro_w,0)	= 0) then

		if (coalesce(ds_erro_w::text, '') = '') or (length(ds_erro_w) < 3900) then

			if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then

				ds_erro_w	:= ds_erro_w || chr(13) || chr(10);

			end if;

			ds_erro_w	:= WHEB_MENSAGEM_PCK.get_texto(281511) || nr_repasse_terceiro_w || WHEB_MENSAGEM_PCK.get_texto(281512);

		end if;

	else

		insert	into repasse_terceiro_hist(ds_historico,
			dt_atualizacao,
			dt_historico,
			nm_usuario,
			nr_repasse_terceiro,
			nr_sequencia)
		values (ds_historico_w,
			clock_timestamp(),
			coalesce(dt_historico_w,clock_timestamp()),
			coalesce(nm_usuario_p,'Tasy'),
			nr_repasse_terceiro_w,
			nextval('repasse_terceiro_hist_seq'));

	end if;

end	loop;
close	c01;

delete	from w_repasse_terceiro_hist
where (nm_usuario = nm_usuario_p or coalesce(nm_usuario_p::text, '') = '');

ds_erro_p	:= ds_erro_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_hist_rep_integracao (nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
