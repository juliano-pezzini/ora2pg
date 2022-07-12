-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_isbt_doador ( nr_seq_doacao_p bigint, nr_seq_producao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
B = Barras
D = Descritivo
*/
ds_retorno_w		varchar(255);
cd_local_isbt_w		varchar(5);
dt_coleta_w		timestamp;
nr_seq_isbt_w		integer;


BEGIN
if	((coalesce(nr_seq_doacao_p,0) > 0 ) or (coalesce(nr_seq_producao_p,0) > 0)) then

	select	max(cd_local_isbt)
	into STRICT	cd_local_isbt_w
	from	san_parametro
	where	cd_estabelecimento	= coalesce(wheb_usuario_pck.get_cd_estabelecimento,1);

	select	max(a.dt_doacao),
		coalesce(max(nr_seq_isbt),0),
		coalesce(max(a.cd_local_isbt),0)
	into STRICT	dt_coleta_w,
		nr_seq_isbt_w,
		cd_local_isbt_w
	from (
		SELECT	dt_doacao dt_doacao,
			nr_seq_isbt nr_seq_isbt,
			cd_local_isbt_w cd_local_isbt
		from	san_doacao
		where	nr_sequencia	= nr_seq_doacao_p
		
union

		SELECT	a.dt_producao,
			a.nr_seq_isbt,
			c.cd_local_isbt
		from	san_producao a,
			san_emprestimo b,
			san_entidade c
		where	a.nr_seq_emp_ent = b.nr_sequencia
		and	c.nr_sequencia = b.nr_seq_entidade
		and	a.nr_sequencia	= nr_seq_producao_p
		and	coalesce(nr_seq_doacao_p::text, '') = '') a;



	--'Código local ISBT' + Ano da data de coleta com 2 dígitos + sequência interna ISBT da doação + bandeira/sinal
	if (ie_opcao_p = 'B') then
		ds_retorno_w	:= '='||lpad(cd_local_isbt_w,5,0) || to_char(dt_coleta_w,'yy') || LPAD(nr_seq_isbt_w,6,0);
	elsif (ie_opcao_p = 'I') then
		ds_retorno_w	:= lpad(cd_local_isbt_w,5,0) || to_char(dt_coleta_w,'yy') || LPAD(nr_seq_isbt_w,6,0);
	else
		ds_retorno_w	:= lpad(cd_local_isbt_w,5,0) ||' '|| to_char(dt_coleta_w,'yy') ||' '|| LPAD(nr_seq_isbt_w,6,0);
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_isbt_doador ( nr_seq_doacao_p bigint, nr_seq_producao_p bigint, ie_opcao_p text) FROM PUBLIC;

