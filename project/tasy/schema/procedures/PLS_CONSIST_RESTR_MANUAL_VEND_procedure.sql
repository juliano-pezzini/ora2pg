-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consist_restr_manual_vend ( nr_seq_solicitacao_p bigint, nr_seq_vendedor_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


dt_solicitacao_w		timestamp;
ie_origem_solicitacao_w		varchar(10);
ds_erro_w			varchar(255)	:= null;
nr_seq_restricao_w		bigint;
nr_seq_regra_restricao_w	bigint;
qt_dias_solic_inicial_w		bigint;
qt_dias_solic_final_w		bigint;
qt_dias_solicitacao_w		bigint;
qt_registros_w			integer;
ie_consiste_w			varchar(10);

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_restricao_vendedor	a
	where	clock_timestamp()	between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp())
	and	a.nr_seq_restricao	= nr_seq_restricao_w
	and	exists (	SELECT	1
				from	pls_solic_regra_restricao	x
				where	x.nr_seq_regra		= a.nr_sequencia
				and	x.ie_origem_solicitacao	= ie_origem_solicitacao_w)
	order by CASE WHEN coalesce(qt_dias_solic_inicial::text, '') = '' THEN 1  ELSE -1 END ,
		CASE WHEN coalesce(qt_dias_solic_final::text, '') = '' THEN 1  ELSE -1 END;


BEGIN

if (coalesce(nr_seq_vendedor_p,0) <> 0) then
	select	dt_solicitacao,
		ie_origem_solicitacao
	into STRICT	dt_solicitacao_w,
		ie_origem_solicitacao_w
	from	pls_solicitacao_comercial
	where	nr_sequencia	= nr_seq_solicitacao_p;

	select	nr_seq_restricao
	into STRICT	nr_seq_restricao_w
	from	pls_vendedor
	where	nr_sequencia	= nr_seq_vendedor_p;

	ie_consiste_w	:= 'N';

	if (nr_seq_restricao_w IS NOT NULL AND nr_seq_restricao_w::text <> '') then
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_restricao_vendedor
		where	clock_timestamp()	between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp());

		if (qt_registros_w > 0) then
			ie_consiste_w	:= 'S';

			open C01;
			loop
			fetch C01 into
				nr_seq_regra_restricao_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin

				select	qt_dias_solic_inicial,
					qt_dias_solic_final
				into STRICT	qt_dias_solic_inicial_w,
					qt_dias_solic_final_w
				from	pls_restricao_vendedor
				where	nr_sequencia	= nr_seq_regra_restricao_w;

				qt_dias_solicitacao_w	:= obter_dias_entre_datas(dt_solicitacao_w,clock_timestamp());

				if (qt_dias_solicitacao_w between coalesce(qt_dias_solic_inicial_w,qt_dias_solicitacao_w) and coalesce(qt_dias_solic_final_w,qt_dias_solicitacao_w)) then
					ie_consiste_w	:= 'N';
					exit;
				end if;

				end;
			end loop;
			close C01;
		end if;
	end if;

	if (ie_consiste_w = 'S') then
		ds_erro_w	:= wheb_mensagem_pck.get_texto(280714);
	end if;
end if;

ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consist_restr_manual_vend ( nr_seq_solicitacao_p bigint, nr_seq_vendedor_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

