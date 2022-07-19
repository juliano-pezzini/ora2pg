-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_cco_sib ( nr_seq_lote_sib_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_cco_w			bigint;
ie_digito_cco_w			smallint;
nr_seq_segurado_w		bigint;
nr_seq_retorno_sib_w		bigint;
ie_tipo_reg_w			smallint;
cd_cco_w			pls_segurado.cd_cco%type;

C00 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.nr_sequencia
	from	pls_retorno_sib 	a,
		pls_segurado		b,
		pls_lote_retorno_sib	c
	where	a.nr_seq_lote_sib	= c.nr_sequencia
	and	b.nr_cco		= a.nr_cco
	and	b.ie_digito_cco		= a.ie_digito_cco
	and	(b.nr_cco IS NOT NULL AND b.nr_cco::text <> '')
	and	c.nr_sequencia		= nr_seq_lote_sib_p
	and	ie_opcao_p		= 'N'
	order by b.nr_sequencia;

C01 CURSOR FOR
	SELECT	1 ie_tipo_reg,
		a.nr_sequencia,
		a.nr_cco,
		a.ie_digito_cco,
		c.nr_sequencia
	from	pls_retorno_sib a,
		pls_segurado_carteira b,
		pls_segurado c
	where	a.cd_usuario_plano	= coalesce(c.cd_cartao_ident_ans_sist_ant,b.cd_usuario_plano)
	and	b.nr_seq_segurado	= c.nr_sequencia
	and	a.nr_seq_lote_sib	= nr_seq_lote_sib_p
	and	coalesce(c.nr_cco::text, '') = ''
	and	ie_opcao_p	= 'N'
	
UNION ALL

	SELECT	2 ie_tipo_reg,
		a.nr_sequencia,
		a.nr_cco,
		a.ie_digito_cco,
		a.nr_seq_segurado_vinculado
	from	pls_retorno_sib a
	where	a.nr_seq_lote_sib	= nr_seq_lote_sib_p
	and	(a.nr_seq_segurado_vinculado IS NOT NULL AND a.nr_seq_segurado_vinculado::text <> '')
	and	coalesce(a.nr_seq_segurado::text, '') = ''
	and	ie_opcao_p	= 'V'
	
UNION ALL

	select	3 ie_tipo_reg,
		a.nr_sequencia,
		a.nr_cco,
		a.ie_digito_cco,
		c.nr_sequencia
	from	pls_retorno_sib a,
		pls_segurado_carteira b,
		pls_segurado c
	where	a.cd_usuario_plano	= coalesce(c.cd_cartao_ident_ans_sist_ant,b.cd_usuario_plano)
	and	b.nr_seq_segurado	= c.nr_sequencia
	and	a.nr_seq_lote_sib	= nr_seq_lote_sib_p
	and	(c.nr_cco IS NOT NULL AND c.nr_cco::text <> '')
	and	ie_opcao_p	= 'N'
	order by 5;


BEGIN

/*aaschlote 06/06/2011 OS - 324926 -Identificar o beneficiário primeiro como o número do CCO*/

open C00;
loop
fetch C00 into
	nr_seq_retorno_sib_w,
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin

	update	pls_retorno_sib
	set	nr_seq_segurado_encontrado	= nr_seq_segurado_w,
		dt_atualizacao			= clock_timestamp(),
		nm_usuario			= nm_usuario_p
	where	nr_sequencia			= nr_seq_retorno_sib_w;

	end;
end loop;
close C00;

open C01;
loop
fetch C01 into
	ie_tipo_reg_w,
	nr_seq_retorno_sib_w,
	nr_cco_w,
	ie_digito_cco_w,
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (ie_tipo_reg_w = 3) then
		update	pls_retorno_sib
		set	nr_seq_segurado_encontrado	= nr_seq_segurado_w,
			dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p
		where	nr_sequencia			= nr_seq_retorno_sib_w;
	elsif (coalesce(nr_seq_segurado_w,0) > 0) then
		cd_cco_w	:= lpad(nr_cco_w,10,0)||lpad(ie_digito_cco_w,2,0);
		update	pls_segurado
		set	nr_cco		= nr_cco_w,
			ie_digito_cco	= ie_digito_cco_w,
			cd_cco		= cd_cco_w,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_segurado_w;

		update	pls_retorno_sib
		set	nr_seq_segurado	= nr_seq_segurado_w,
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_retorno_sib_w;
	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_cco_sib ( nr_seq_lote_sib_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

