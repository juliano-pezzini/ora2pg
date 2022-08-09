-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_baixa_gratuidade ( nr_titulo_receber_p bigint, nr_seq_baixa_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w		smallint;
ie_repasse_gratuidade_w 	varchar(1)	:= null;
vl_glosa_w			double precision;
ie_tipo_consistencia_w		integer;
ie_libera_repasse_gratuidade_w	varchar(1)	:= 'N';


BEGIN

select	max(ie_tipo_consistencia)
into STRICT	ie_tipo_consistencia_w
from	titulo_receber_liq a,
	tipo_recebimento b
where	a.cd_tipo_recebimento	= b.cd_tipo_recebimento
and	a.nr_titulo		= nr_titulo_receber_p
and	a.nr_sequencia		= nr_seq_baixa_p;

if (ie_tipo_consistencia_w = 9) then

	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	titulo_receber
	where	nr_titulo	= nr_titulo_receber_p;

	select	max(ie_repasse_gratuidade)
	into STRICT	ie_repasse_gratuidade_w
	from	convenio_estabelecimento b,
		titulo_receber a
	where	coalesce(a.cd_convenio_conta,obter_convenio_tit_rec(a.nr_titulo)) = b.cd_convenio
	and	a.cd_estabelecimento	= b.cd_estabelecimento
	and	a.nr_titulo	= nr_titulo_receber_p;

	if (coalesce(ie_repasse_gratuidade_w,'P') = 'P') then

		begin
		select	coalesce(ie_repasse_gratuidade,'N')
		into STRICT	ie_repasse_gratuidade_w
		from	parametro_faturamento
		where	cd_estabelecimento = cd_estabelecimento_w;
		exception
			when others then
			-- Os parâmetros do faturamento deste estabelecimento não estão cadastrados!
			CALL wheb_mensagem_pck.exibir_mensagem_abort(267111);
		end;
	end if;

	select	coalesce(vl_glosa,0)
	into STRICT	vl_glosa_w
	from	titulo_receber_liq
	where	nr_titulo	= nr_titulo_receber_p
	and	nr_sequencia	= nr_seq_baixa_p;

/*	Edgar 19/03/2008, OS 86492, alterei para chamar esta procedure sempre que lançada a baixa

	gerar_titulo_rec_liq_cc	(cd_estabelecimento_w,
				null,
				nm_usuario_p,
				nr_titulo_receber_p,
				nr_seq_baixa_p);

*/
	if (ie_repasse_gratuidade_w in ('S','L')) then
		CALL Atualizar_repasse_gratuidade(nr_titulo_receber_p,vl_glosa_w,nm_usuario_p,ie_repasse_gratuidade_w);
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_baixa_gratuidade ( nr_titulo_receber_p bigint, nr_seq_baixa_p bigint, nm_usuario_p text) FROM PUBLIC;
