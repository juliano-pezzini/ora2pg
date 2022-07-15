-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_retorno_citibank_240_reg ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*===========================================================
	             =>>>>>	A T E N Ç Ã O        <<<<<<=

Esta procedure é uma cópia da gerar_retorno_citibank_240,
para atender a OS 1195116, porém não foi validada com retorno bancario

Como se trata de um projeto e não possuímos cliente para validar junto
ao banco, os defeitos devem ser verificados com o analista (Peterson) antes
de serem documentados.
============================================================*/
ds_titulo_w				varchar(15);
ds_observacao_w			varchar(255);
vl_titulo_w				titulo_receber.vl_titulo%type;
vl_saldo_inclusao_w		titulo_receber.vl_saldo_titulo%type;
nr_sequencia_w			w_retorno_banco.nr_sequencia%type;
nr_titulo_w				titulo_receber.nr_titulo%type;
nr_sequencia_banco_w 	w_retorno_banco.nr_sequencia%type;
nr_nosso_numero_w		varchar(20);
nr_seq_reg_u_w			w_retorno_banco.nr_sequencia%type;
ds_dt_liquidacao_w		varchar(8);
nr_seq_ocorrencia_ret_w	banco_ocorr_escrit_ret.nr_sequencia%type;
cd_banco_w				banco.cd_banco%type;
nr_seq_tipo_cobranca_w	cobranca_escritural.nr_seq_tipo%type;
vl_acrescimo_w			titulo_receber_cobr.vl_acrescimo%type;
vl_desconto_w			titulo_receber_cobr.vl_desconto%type;
vl_abatimento_w			double precision;
vl_liquido_w			titulo_receber_cobr.vl_liquidacao%type;
vl_outras_despesas_w	titulo_receber_cobr.vl_despesa_bancaria%type;
dt_liquidacao_w			timestamp;
cd_ocorrencia_w			varchar(2);
nr_seq_ocorr_motivo_w	banco_ocorr_motivo_ret.nr_sequencia%type;
ds_dt_credito_banco_w	varchar(8);
dt_credito_banco_w		timestamp;
vl_saldo_titulo_w		titulo_receber.vl_saldo_titulo%type;

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
			trim(both substr(a.ds_string,38,20)),
			trim(both substr(a.ds_string,59,15))
	from	w_retorno_banco a
	where	a.nr_seq_cobr_escrit			= nr_seq_cobr_escrit_p
	and		substr(ds_string,8,1)			= '3'
	and 	trim(both substr(a.ds_string,14,1))	= 'T';


BEGIN

select	max(a.nr_seq_tipo)
into STRICT	nr_seq_tipo_cobranca_w
from	cobranca_escritural a
where	a.nr_sequencia = nr_seq_cobr_escrit_p;

select	max(trim(both substr(ds_string,146,8)))
into STRICT	ds_dt_credito_banco_w
from	w_retorno_banco
where	nr_seq_cobr_escrit			= nr_seq_cobr_escrit_p
and		substr(ds_string,8,1)		= '3'
and		substr(ds_string,14,1)		= 'U'
and		substr(ds_string,138,8) 	<> '00000000';

begin
	dt_credito_banco_w := to_date(ds_dt_credito_banco_w,'dd/mm/yyyy');
exception when others then
	dt_credito_banco_w := null;
end;

update	cobranca_escritural
set		dt_credito_bancario		= dt_credito_banco_w
where	nr_sequencia			= nr_seq_cobr_escrit_p;

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	nr_nosso_numero_w,
	ds_titulo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	max(a.nr_titulo)
	into STRICT	nr_titulo_w
	from	titulo_receber a
	where	a.nr_titulo = somente_numero(ds_titulo_w);

	if (coalesce(nr_titulo_w::text, '') = '') then

		select	max(a.nr_titulo)
		into STRICT	nr_titulo_w
		from	titulo_receber a
		where	(a.nr_nosso_numero IS NOT NULL AND a.nr_nosso_numero::text <> '')
		and		a.nr_nosso_numero = nr_nosso_numero_w;

	end if;

	/*Se achou o título importa, senão grava log de não importação.*/

	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then

		select	max(vl_saldo_titulo),
				max(vl_titulo)
		into STRICT	vl_saldo_titulo_w,
				vl_titulo_w
		from	titulo_receber
		where	nr_titulo	= nr_titulo_w;

		nr_seq_reg_u_w	:= nr_sequencia_w + 1;

		select	coalesce((substr(ds_string,20,13))::numeric /100,0),
				coalesce((substr(ds_string,35,13))::numeric /100,0),
				coalesce((substr(ds_string,15,13))::numeric /100,0),
				coalesce((substr(ds_string,95,13))::numeric /100,0),
				coalesce((substr(ds_string,110,13))::numeric /100,0),
				substr(ds_string,138,8),
				substr(ds_string,16,2),
				substr(ds_string,1,3)
		into STRICT	vl_acrescimo_w,
				vl_desconto_w,
				vl_abatimento_w,
				vl_liquido_w,
				vl_outras_despesas_w,
				ds_dt_liquidacao_w,
				cd_ocorrencia_w,
				cd_banco_w
		from	w_retorno_banco
		where	nr_sequencia	= nr_seq_reg_u_w;

		begin
			dt_liquidacao_w := to_date(ds_dt_liquidacao_w,'dd/mm/yyyy');
		exception when others then
			dt_liquidacao_w := clock_timestamp();
		end;

		/*Buscar ocorrência*/

		select 	max(a.nr_sequencia)
		into STRICT	nr_seq_ocorrencia_ret_w
		from	banco_ocorr_escrit_ret a
		where	a.cd_banco 				= cd_banco_w
		and 	coalesce(a.nr_seq_tipo,0) 	= coalesce(nr_seq_tipo_cobranca_w,0)
		and		a.cd_ocorrencia 		= cd_ocorrencia_w;

		select	max(a.nr_sequencia)
		into STRICT	nr_seq_ocorr_motivo_w
		from	banco_ocorr_motivo_ret a
		where	position(a.cd_motivo in cd_ocorrencia_w)	> 0
		and	a.nr_seq_escrit_ret			= nr_seq_ocorrencia_ret_w;

		insert	into titulo_receber_cobr(	nr_sequencia,
											NR_TITULO,
											CD_BANCO,
											VL_COBRANCA,
											VL_DESCONTO,
											VL_ACRESCIMO,
											VL_DESPESA_BANCARIA,
											VL_LIQUIDACAO,
											DT_LIQUIDACAO,
											DT_ATUALIZACAO,
											NM_USUARIO,
											NR_SEQ_COBRANCA,
											nr_seq_ocorrencia_ret,
											nr_seq_ocorr_motivo,
											vl_saldo_inclusao)
								values (	nextval('titulo_receber_cobr_seq'),
											nr_titulo_w,
											cd_banco_w,
											vl_titulo_w,
											vl_desconto_w,
											vl_acrescimo_w,
											vl_outras_despesas_w,
											vl_liquido_w,
											dt_liquidacao_w,
											clock_timestamp(),
											nm_usuario_p,
											nr_seq_cobr_escrit_p,
											nr_seq_ocorrencia_ret_w,
											nr_seq_ocorr_motivo_w,
											vl_saldo_titulo_w);
	else
		CALL gerar_log_escritural('C',nr_seq_cobr_escrit_p,nm_usuario_p,wheb_mensagem_pck.get_texto(457781, 'ds_titulo_w=' || coalesce(ds_titulo_w,nr_nosso_numero_w)),'S');
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
-- REVOKE ALL ON PROCEDURE gerar_retorno_citibank_240_reg ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

