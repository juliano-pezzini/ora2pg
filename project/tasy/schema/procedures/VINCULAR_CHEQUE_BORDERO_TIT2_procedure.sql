-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_cheque_bordero_tit2 ( nr_seq_cheque_p bigint, nr_bordero_p bigint, nr_titulo_p bigint, nm_usuario_p text, vl_cheque_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


vl_cheques_w		double precision;
vl_titulo_w		double precision;
vl_saldo_titulo_w	double precision;
ie_soma_cheque_maior_w	varchar(255);
ie_valida_vl_titulo_w	varchar(1);


BEGIN

if (nr_seq_cheque_p IS NOT NULL AND nr_seq_cheque_p::text <> '') and
	((nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') or (nr_bordero_p IS NOT NULL AND nr_bordero_p::text <> '')) then

	ie_soma_cheque_maior_w := obter_param_usuario(127, 38, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_soma_cheque_maior_w);
	ie_valida_vl_titulo_w := obter_param_usuario(127, 50, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_valida_vl_titulo_w);
	if (ie_soma_cheque_maior_w	= 'N') and (coalesce(nr_titulo_p,0) > 0) then

		select	vl_titulo,
			vl_saldo_titulo
		into STRICT	vl_titulo_w,
			vl_saldo_titulo_w
		from	titulo_pagar
		where	nr_titulo	= nr_titulo_p;

		select	coalesce(sum(c.vl_cheque),0)
		into STRICT	vl_cheques_w
		from	cheque c,
			cheque_bordero_titulo b
		where	c.nr_sequencia 	= b.nr_seq_cheque
		and	b.nr_titulo	= nr_titulo_p
                                and          coalesce(c.dt_cancelamento::text, '') = '';

		if (coalesce(ie_valida_vl_titulo_w,'T') = 'S') then
			if	((vl_cheques_w + coalesce(vl_cheque_p,0)) > vl_saldo_titulo_w) then
				--'A soma dos cheques vinculados ao título ' || nr_titulo_p || ' supera o saldo do título! Parâmetro [38]');
				CALL wheb_mensagem_pck.exibir_mensagem_abort(361924,'NR_TITULO_P='||nr_titulo_p);
			end if;
		else
			if	((vl_cheques_w + coalesce(vl_cheque_p,0)) > vl_titulo_w) then
				--'A soma dos cheques vinculados ao título ' || nr_titulo_p || ' supera o valor do título! Parâmetro [38]');
				CALL wheb_mensagem_pck.exibir_mensagem_abort(184631,'NR_TITULO_P='||nr_titulo_p);
			end if;
		end if;
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_cheque_bordero_tit2 ( nr_seq_cheque_p bigint, nr_bordero_p bigint, nr_titulo_p bigint, nm_usuario_p text, vl_cheque_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

