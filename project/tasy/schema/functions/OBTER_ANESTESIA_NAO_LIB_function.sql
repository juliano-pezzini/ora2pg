-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_anestesia_nao_lib (nr_cirurgia_p bigint, nr_seq_pepo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		                 varchar(1);
qt_tec_anest_sem_liberacao_w	 bigint;
qt_desc_anest_sem_liberacao_w	 bigint;


BEGIN
ds_retorno_w := 'N';
if (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '')
or (nr_seq_pepo_p IS NOT NULL AND nr_seq_pepo_p::text <> '') then

	select 	count(*)
	into STRICT 	qt_tec_anest_sem_liberacao_w
	from	cirurgia_tec_anestesica
	where	((nr_cirurgia 	= nr_cirurgia_p)     or (nr_cirurgia_p = 0))
	and	((nr_seq_pepo 	= nr_seq_pepo_p) or (nr_seq_pepo_p = 0))
	and	nm_usuario 	= wheb_usuario_pck.get_nm_usuario
	and	coalesce(dt_liberacao::text, '') = '';

	select 	count(*)
	into STRICT 	qt_desc_anest_sem_liberacao_w
	from	anestesia_descricao
	where	((nr_cirurgia 	= nr_cirurgia_p)     or (nr_cirurgia_p = 0))
	and	((nr_seq_pepo 	= nr_seq_pepo_p) or (nr_seq_pepo_p = 0))
	and	nm_usuario 	= wheb_usuario_pck.get_nm_usuario
	and	coalesce(dt_liberacao::text, '') = '';

	if (qt_tec_anest_sem_liberacao_w > 0)
	or (qt_desc_anest_sem_liberacao_w > 0) then
		ds_retorno_w := 'S';
	else
		ds_retorno_w := 'N';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_anestesia_nao_lib (nr_cirurgia_p bigint, nr_seq_pepo_p bigint) FROM PUBLIC;
