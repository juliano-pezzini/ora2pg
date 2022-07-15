-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_calcular_preco_atividade ( nr_sequencia_p bigint) AS $body$
DECLARE



cd_setor_w				integer;
dt_atividade_w				timestamp;
ie_calcula_valor_w				varchar(1);
nm_usuario_w				varchar(15);
nr_seq_controle_w				bigint;
nr_seq_funcao_w				bigint;
vl_preco_w				double precision	:= 0;
vl_venda_w				double precision	:= 0;

C01 CURSOR FOR
	SELECT	vl_preco,
		vl_preco_venda
	from 	man_preco_funcao
	where	nr_seq_tipo_funcao	= nr_seq_funcao_w
	and	dt_vigencia	<= dt_atividade_w
	and	coalesce(cd_setor_atendimento,cd_setor_w) = cd_setor_w
	order by	dt_vigencia;


BEGIN

begin
select	coalesce(c.ie_calcula_valor,'N'),
	a.nr_seq_funcao,
	c.cd_setor,
	a.dt_atividade,
	a.nm_usuario_exec
into STRICT	ie_calcula_valor_w,
	nr_seq_funcao_w,
	cd_setor_w,
	dt_atividade_w,
	nm_usuario_w
from	man_localizacao c,
	man_Ordem_servico b,
	man_ordem_serv_ativ a
where	a.nr_seq_ordem_serv 	= b.nr_sequencia
and	b.nr_seq_localizacao	= c.nr_sequencia
and	a.nr_sequencia		= nr_sequencia_p;
exception
when others then
	ie_calcula_valor_w := 'N';
end;

if (ie_calcula_valor_w = 'S') then
	begin
	OPEN C01;
	LOOP
	FETCH C01 into
		vl_preco_w,
		vl_venda_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		vl_preco_w		:= vl_preco_w;
	END LOOP;
	CLOSE C01;
	update	Man_ordem_serv_ativ
	set	vl_cobranca		= vl_preco_w * coalesce(qt_minuto_cobr,0) / 60,
		vl_cobranca_venda		= vl_venda_w * coalesce(qt_minuto_cobr,0) / 60
	where	nr_sequencia		= nr_sequencia_p;
	end;
end if;

select	max(nr_sequencia)
into STRICT	nr_seq_controle_w
from	usuario_controle
where	nm_usuario	= nm_usuario_w
and	dt_referencia	= trunc(dt_atividade_w,'dd');

if (coalesce(nr_seq_controle_w,0) > 0) then
	CALL atualizar_ativ_usuario(nr_seq_controle_w);
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_calcular_preco_atividade ( nr_sequencia_p bigint) FROM PUBLIC;

