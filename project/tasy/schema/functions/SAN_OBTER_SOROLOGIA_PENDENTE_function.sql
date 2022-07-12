-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_sorologia_pendente (nr_seq_doacao_p bigint) RETURNS varchar AS $body$
DECLARE


 ie_sorologia_pend_w	varchar(1) := 'N';

BEGIN

 if (coalesce(nr_seq_doacao_p,0) > 0) then

	select	coalesce(max('S'),'N')
	into STRICT	ie_sorologia_pend_w
	from	san_doacao a,
		san_exame_realizado b,
		san_exame_lote c
	where	a.nr_sequencia		= c.nr_seq_doacao
	and	b.nr_seq_exame_lote	= c.nr_sequencia
	and	a.nr_sequencia		= nr_seq_doacao_p
	and	coalesce(b.dt_liberacao::text, '') = ''
	and (san_obter_se_exame_auxiliar(b.nr_seq_exame_lote, b.nr_seq_exame, wheb_usuario_pck.get_cd_estabelecimento, 'S') = 'S');

 end if;

 return	ie_sorologia_pend_w;

 end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_sorologia_pendente (nr_seq_doacao_p bigint) FROM PUBLIC;

