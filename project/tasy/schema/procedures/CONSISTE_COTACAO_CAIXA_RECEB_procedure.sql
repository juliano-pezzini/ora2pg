-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_cotacao_caixa_receb ( nr_seq_caixa_rec_p bigint, ie_cotacao_dif_p INOUT text) AS $body$
DECLARE


cd_moeda_w		integer;
vl_cotacao_ant_w	cotacao_moeda.vl_cotacao%type;
vl_cotacao_w	cotacao_moeda.vl_cotacao%type;

c01 CURSOR FOR
	SELECT	distinct cd_moeda
	from	caixa_receb_estrang
	where	nr_seq_caixa_receb	= nr_seq_caixa_rec_p
	and	(cd_moeda IS NOT NULL AND cd_moeda::text <> '')
	
union

	/* Títulos */

	SELECT	distinct cd_moeda
	from	titulo_receber_liq
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and	(cd_moeda IS NOT NULL AND cd_moeda::text <> '')
	
union

	/* Adiantamento */

	select	distinct cd_moeda
	from	adiantamento
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and	(cd_moeda IS NOT NULL AND cd_moeda::text <> '')
	
union

	/* Cheque */

	select	distinct cd_moeda
	from	cheque_cr
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and	(cd_moeda IS NOT NULL AND cd_moeda::text <> '')
	
union

	/* Outros documentos */

	select	distinct a.cd_moeda
	from	movto_trans_financ a,
		transacao_financeira b
	where	a.nr_seq_trans_financ = b.nr_sequencia
	and	b.ie_caixa = 'D'
	and	coalesce(a.nr_seq_titulo_receber::text, '') = ''
	and	coalesce(a.nr_adiantamento::text, '') = ''
	and	a.nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and 	(a.cd_moeda IS NOT NULL AND a.cd_moeda::text <> '')
	
union

	/* Troca de Valores */

	select	distinct cd_moeda
	from	adiantamento_pago
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and	(cd_moeda IS NOT NULL AND cd_moeda::text <> '');

c02 CURSOR FOR
	SELECT	distinct vl_cotacao
	from	caixa_receb_estrang
	where	nr_seq_caixa_receb = nr_seq_caixa_rec_p
	and	cd_moeda = cd_moeda_w
	and	(vl_cotacao IS NOT NULL AND vl_cotacao::text <> '')
	
union

	/* Títulos */

	SELECT	distinct vl_cotacao
	from	titulo_receber_liq
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and	cd_moeda = cd_moeda_w
	and	(vl_cotacao IS NOT NULL AND vl_cotacao::text <> '')
	
union

	/* Adiantamento */

	select	distinct vl_cotacao
	from	adiantamento
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and	cd_moeda = cd_moeda_w
	and	(vl_cotacao IS NOT NULL AND vl_cotacao::text <> '')
	
union

	/* Cheque */

	select	distinct vl_cotacao
	from	cheque_cr
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and	cd_moeda = cd_moeda_w
	and	(vl_cotacao IS NOT NULL AND vl_cotacao::text <> '')
	
union

	/* Outros documentos */

	select	distinct a.vl_cotacao
	from	movto_trans_financ a,
		transacao_financeira b
	where	a.nr_seq_trans_financ = b.nr_sequencia
	and	b.ie_caixa = 'D'
	and	coalesce(a.nr_seq_titulo_receber::text, '') = ''
	and	coalesce(a.nr_adiantamento::text, '') = ''
	and	a.nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and 	a.cd_moeda = cd_moeda_w
	and	(a.vl_cotacao IS NOT NULL AND a.vl_cotacao::text <> '')
	
union

	/* Troca de Valores */

	select	distinct vl_cotacao
	from	adiantamento_pago
	where	nr_seq_caixa_rec = nr_seq_caixa_rec_p
	and	cd_moeda = cd_moeda_w
	and	(vl_cotacao IS NOT NULL AND vl_cotacao::text <> '');


BEGIN
ie_cotacao_dif_p := 'N';

open c01;
loop
fetch c01 into
	cd_moeda_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	open c02;
	loop
	fetch c02 into
		vl_cotacao_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		if coalesce(vl_cotacao_ant_w::text, '') = '' then
			vl_cotacao_ant_w := vl_cotacao_w;
		end if;

		if vl_cotacao_w <> vl_cotacao_ant_w then
			ie_cotacao_dif_p := 'S';
		end if;

	end loop;
	close c02;

	-- Limpa a variável para realizar a consistência para outra moeda
	vl_cotacao_ant_w := null;

end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_cotacao_caixa_receb ( nr_seq_caixa_rec_p bigint, ie_cotacao_dif_p INOUT text) FROM PUBLIC;
