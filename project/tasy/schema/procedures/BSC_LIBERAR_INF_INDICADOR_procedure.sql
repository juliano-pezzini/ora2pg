-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bsc_liberar_inf_indicador ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, ie_operacao_p text, nm_usuario_p text) AS $body$
DECLARE


ie_libera_periodo_w		varchar(1);
nr_seq_calculo_w		bigint;
qt_ind_pendente_w		bigint;
/*
IE_OPERACAO_P
L	= Liberar
E	= Estornar liberação
*/
BEGIN

update	bsc_ind_inf
set	dt_liberacao	= CASE WHEN ie_operacao_p='L' THEN clock_timestamp()  ELSE null END ,
	dt_atualizacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p,
	ie_fechado	= CASE WHEN ie_operacao_p='L' THEN 'F'  ELSE 'A' END
where	nr_sequencia	= nr_sequencia_p;


if (ie_operacao_p	= 'L') then
	begin

	ie_libera_periodo_w	:= coalesce(obter_valor_param_usuario(7024,43, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'N');

	if (ie_libera_periodo_w = 'S') then

		select	max(a.nr_seq_calc)
		into STRICT	nr_seq_calculo_w
		from	bsc_calc_indicador a
		where	nr_seq_inf	= nr_sequencia_p;

		select	count(*)
		into STRICT	qt_ind_pendente_w
		from	bsc_calculo a,
			bsc_calc_indicador b,
			bsc_ind_inf c
		where	a.nr_sequencia		= b.nr_seq_calc
		and	b.nr_seq_indicador		= c.nr_seq_indicador
		and	b.nr_seq_inf		= c.nr_sequencia
		and	coalesce(c.dt_liberacao::text, '') = ''
		and	a.nr_sequencia		= nr_seq_calculo_w;

		if (qt_ind_pendente_w = 0) then
			bsc_liberar_calculo(nr_seq_calculo_w, ie_operacao_p, cd_estabelecimento_p, nm_usuario_p);
		end if;

	end if;

	end;
elsif (ie_operacao_p	= 'E') then
	bsc_liberar_calculo(nr_sequencia_p,'E', cd_estabelecimento_p,nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bsc_liberar_inf_indicador ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, ie_operacao_p text, nm_usuario_p text) FROM PUBLIC;

