-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_inf_adic_qua ( nr_seq_item_inf_p bigint, nr_seq_evento_p bigint, ds_valor_p text, dt_valor_p timestamp default null, nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE


nr_seq_pp_w	bigint;
nr_seq_ppi_w	bigint;
ie_tipo_campo_w	varchar(3);
nr_sequencia_w	bigint;
valida_number_w double precision;

nr_valor_w	bigint;
dt_valor_w	timestamp;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_sequencia_w
from	QUA_EV_PAC_INF_ADIC
where	NR_SEQ_INF_ADIC	= nr_seq_item_inf_p
and	nr_seq_evento	= nr_seq_evento_p;

select	max(ie_tipo_campo)
into STRICT	ie_tipo_campo_w
from	QUA_EVENTO_INF_ADIC
where	nr_sequencia		=	nr_seq_item_inf_p;

if (ie_tipo_campo_w = 'N') then
	begin
		valida_number_w := (ds_valor_p)::numeric;
	exception
	when others then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(399663);
	end;
end if;

/* Alteraçõo para o HTML, devido à internacionalização de datas */

if (ie_tipo_campo_w = 'N') then
	if (ds_valor_p IS NOT NULL AND ds_valor_p::text <> '') then


		nr_valor_w	:= (ds_valor_p)::numeric;
	end if;
end if;

if (ie_tipo_campo_w = 'D') then
	if (dt_valor_p IS NOT NULL AND dt_valor_p::text <> '') then
		dt_valor_w	:= dt_valor_p;
	else
		dt_valor_w	:= to_date(ds_valor_p,'dd/mm/yyyy hh24:mi:ss');
	end if;
end if;

if (nr_sequencia_w = 0) then
	/* inserir o item (insert) */

	insert	into QUA_EV_PAC_INF_ADIC(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		NR_SEQ_INF_ADIC,
		nr_inf_adic,
		ds_inf_adic,
		dt_inf_adic,
		nr_seq_evento)
	values (
		nextval('qua_ev_pac_inf_adic_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_item_inf_p,
		CASE WHEN ie_tipo_campo_w='N' THEN nr_valor_w  ELSE null END ,
		CASE WHEN ie_tipo_campo_w='A' THEN ds_valor_p  ELSE null END ,
		CASE WHEN ie_tipo_campo_w='D' THEN dt_valor_w  ELSE null END ,
		nr_seq_evento_p);
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
else
	/* atualizar o item (update) */

	update	QUA_EV_PAC_INF_ADIC
	set	nr_inf_adic	=	CASE WHEN ie_tipo_campo_w='N' THEN nr_valor_w  ELSE null END ,
		ds_inf_adic	=	substr(CASE WHEN ie_tipo_campo_w='A' THEN ds_valor_p  ELSE null END ,1,2000),
		dt_inf_adic	=	CASE WHEN ie_tipo_campo_w='D' THEN dt_valor_w  ELSE null END ,
		nm_usuario	=	nm_usuario_p,
		dt_atualizacao	=	clock_timestamp()
	where	nr_sequencia	=	nr_sequencia_w;
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
end if;


if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_inf_adic_qua ( nr_seq_item_inf_p bigint, nr_seq_evento_p bigint, ds_valor_p text, dt_valor_p timestamp default null, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;
