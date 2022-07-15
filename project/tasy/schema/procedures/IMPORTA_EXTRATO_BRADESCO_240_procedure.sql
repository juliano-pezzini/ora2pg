-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importa_extrato_bradesco_240 ( nr_seq_extrato_p bigint) AS $body$
DECLARE


/* Layout CNAB Versão 3.0 de 16/09/2011 */

nr_seq_conta_W		bigint;
vl_saldo_inicial_w	double precision;
vl_saldo_final_w	double precision;
dt_saldo_inicial_w	timestamp;
dt_saldo_final_w	timestamp;
nr_seq_extrato_w	bigint;
nr_seq_conta_nova_w	bigint;
nr_conta_ant_w		varchar(12)	:= '-1';
ie_digito_ant_w		varchar(1);
ie_deb_cred_saldo_ini_w	varchar(1);
ie_deb_cred_saldo_fin_w	varchar(1);
cd_banco_w		smallint;
ie_atualizar_extrato_lanc_w varchar(1)	 := 'N';

/* Registro detalhe */

nr_documento_w		varchar(20);
dt_lancamento_w		varchar(8);
vl_lancamento_w		varchar(18);
ie_deb_cred_w		varchar(1);
nr_conta_w		varchar(12);
digito_conta_w		varchar(1);
ds_historico_w		varchar(25);
qt_conta_w		bigint;

c01 CURSOR FOR
SELECT	substr(ds_conteudo,202,20) nr_documento,
	substr(ds_conteudo,143,8) dt_lancto,
	substr(ds_conteudo,151,18) vl_lancto,
	substr(ds_conteudo,169,1) ie_cred_deb,
	substr(ds_conteudo,59,12) nr_conta,
	substr(ds_conteudo,71,1) digito_conta,
	substr(ds_conteudo,177,25) ds_historico
from	W_interf_concil
where	substr(ds_conteudo,8,1)	= '3'
and	nr_seq_conta		= nr_seq_conta_W;


BEGIN

ie_atualizar_extrato_lanc_w := Obter_Valor_Param_Usuario(814, 47, Obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, 0);

Select	max(b.nr_seq_conta),
	max(a.cd_banco)
into STRICT	nr_seq_conta_w,
	cd_banco_w
from	banco_estabelecimento a,
	banco_extrato b
where	b.nr_seq_conta	= a.nr_sequencia
and	b.nr_sequencia	= nr_seq_extrato_p;

open c01;
loop
fetch c01 into
	nr_documento_w,
	dt_lancamento_w,
	vl_lancamento_w,
	ie_deb_cred_w,
	nr_conta_w,
	digito_conta_w,
	ds_historico_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (nr_conta_ant_w	= '-1') or (nr_conta_ant_w <> nr_conta_w) or (ie_digito_ant_w <> digito_conta_w) then

		nr_conta_ant_w	:= nr_conta_w;
		ie_digito_ant_w := digito_conta_w;

		select	to_date(substr(a.ds_conteudo,143,8),'dd/mm/yyyy') dt_lancto,
			somente_numero(substr(a.ds_conteudo,151,18)) / 100 vl_lancto,
			substr(a.ds_conteudo,169,1) ie_cred_deb
		into STRICT	dt_saldo_inicial_w,
			vl_saldo_inicial_w,
			ie_deb_cred_saldo_ini_w
		from	w_interf_concil a
		where	substr(ds_conteudo,71,1)	= digito_conta_w
		and	substr(ds_conteudo,59,12)	= nr_conta_w
		and	substr(ds_conteudo,8,1)		= '1'
		and	a.nr_seq_conta			= nr_seq_conta_w;

		select	to_date(substr(a.ds_conteudo,143,8),'dd/mm/yyyy') dt_lancto,
			somente_numero(substr(a.ds_conteudo,151,18)) / 100 vl_lancto,
			substr(a.ds_conteudo,169,1) ie_cred_deb
		into STRICT	dt_saldo_final_w,
			vl_saldo_final_w,
			ie_deb_cred_saldo_fin_w
		from	w_interf_concil a
		where	substr(ds_conteudo,71,1)	= digito_conta_w
		and	substr(ds_conteudo,59,12)	= nr_conta_w
		and	substr(ds_conteudo,8,1)		= '5'
		and	a.nr_seq_conta			= nr_seq_conta_w;

		select	max(a.nr_sequencia),
			count(*)
		into STRICT	nr_seq_conta_nova_w,
			qt_conta_w
		from	banco_estabelecimento a
		where	coalesce(a.ie_situacao,'A')			= 'A'
		and	somente_numero(a.ie_digito_conta)	= somente_numero(digito_conta_w)
		and	somente_numero(a.cd_conta)		= somente_numero(nr_conta_w)
		and	cd_banco				= cd_banco_w;

		if (qt_conta_w	> 1) then

			select	max(a.nr_sequencia)
			into STRICT	nr_seq_conta_nova_w
			from	conta_banco_tipo b,
				banco_estabelecimento a
			where	coalesce(a.ie_situacao,'A')			= 'A'
			and	b.ie_classif_conta			= 'CC'
			and	a.nr_seq_tipo_conta			= b.nr_sequencia
			and	somente_numero(a.ie_digito_conta)	= somente_numero(digito_conta_w)
			and	somente_numero(a.cd_conta)		= somente_numero(nr_conta_w)
			and	cd_banco				= cd_banco_w;

		end if;

		if (coalesce(nr_seq_conta_nova_w::text, '') = '') then

			nr_seq_conta_nova_w	:= nr_seq_conta_w;

		end if;

		if (ie_deb_cred_saldo_ini_w	= 'D') then
			vl_saldo_inicial_w	:= coalesce(vl_saldo_inicial_w,0) * -1;
		end if;

		if (ie_deb_cred_saldo_fin_w	= 'D') then
			vl_saldo_final_w	:= coalesce(vl_saldo_final_w,0) * -1;
		end if;

		if (nr_seq_conta_w	= nr_seq_conta_nova_w) then

			nr_seq_extrato_w	:= nr_seq_extrato_p;
			nr_seq_conta_nova_w	:= nr_seq_conta_w;

			if (coalesce(ie_atualizar_extrato_lanc_w, 'N') = 'S') then
				update	banco_extrato
				set	vl_saldo_inicial	= vl_saldo_inicial_w,
					vl_saldo_final		= vl_saldo_final_w,
					dt_inicio		= dt_saldo_inicial_w,
					dt_final		= dt_saldo_final_w,
					dt_atualizacao		= clock_timestamp()
				where	nr_sequencia		= nr_seq_extrato_w;
			end if;

		else

			if (nr_seq_conta_nova_w IS NOT NULL AND nr_seq_conta_nova_w::text <> '') then

				select	nextval('banco_extrato_seq')
				into STRICT	nr_seq_extrato_w
				;

				insert	into banco_extrato(dt_atualizacao,
					dt_atualizacao_nrec,
					dt_final,
					dt_importacao,
					dt_inicio,
					nm_usuario,
					nm_usuario_nrec,
					nr_seq_conta,
					nr_sequencia,
					vl_saldo_final,
					vl_saldo_inicial)
				values (clock_timestamp(),
					clock_timestamp(),
					dt_saldo_final_w,
					clock_timestamp(),
					dt_saldo_inicial_w,
					'Tasy',
					'Tasy',
					nr_seq_conta_nova_w,
					nr_seq_extrato_w,
					vl_saldo_final_w,
					vl_saldo_inicial_w);

			end if;

		end if;

	end if;

	if (nr_seq_conta_nova_w IS NOT NULL AND nr_seq_conta_nova_w::text <> '') then

		insert	into banco_extrato_lanc(nr_documento,
			dt_movimento,
			vl_lancamento,
			ie_deb_cred,
			nr_seq_extrato,
			nr_sequencia,
			nm_usuario,
			ie_conciliacao,
			dt_atualizacao,
			ds_historico)
		values (nr_documento_w,
			to_date(dt_lancamento_w,'dd/mm/yyyy'),
			somente_numero(vl_lancamento_w) / 100,
			ie_deb_cred_w,
			nr_seq_extrato_w,
			nextval('banco_extrato_lanc_seq'),
			'Tasy',
			'N',
			clock_timestamp(),
			ds_historico_w);

	end if;

end loop;
close c01;

delete 	from w_interf_concil
where	nr_seq_conta	= nr_seq_conta_W;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importa_extrato_bradesco_240 ( nr_seq_extrato_p bigint) FROM PUBLIC;

