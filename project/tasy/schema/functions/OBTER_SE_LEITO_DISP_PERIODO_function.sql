-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_leito_disp_periodo (cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_temporario_w			varchar(01);
ie_temporario_atual_w		varchar(01);
ie_status_unidade_atual_w		varchar(03);
ie_status_unidade_w		varchar(03);
ie_disponivel_w			varchar(01);
nr_seq_interno_w			bigint;
ie_considera_dt_ref_w		varchar(10);
nr_sequencia_w			bigint	:=	0;
ie_status_unidade_max_w		varchar(03);
ie_temporario_max_w		varchar(01);


c01 CURSOR FOR
SELECT	ie_temporario,
	ie_status_unidade,
	nr_sequencia
from	unidade_atend_hist
where	nr_seq_unidade		= nr_seq_interno_w
and	dt_historico		between trunc(dt_referencia_p, 'dd') and trunc(dt_referencia_p,'dd') + 86399/86400
order by dt_historico;


BEGIN


select	ie_temporario,
	ie_status_unidade,
	nr_seq_interno
into STRICT	ie_temporario_atual_w,
	ie_status_unidade_atual_w,
	nr_seq_interno_w
from	unidade_atendimento
where	cd_setor_atendimento	= cd_setor_atendimento_p
and	cd_unidade_basica	= cd_unidade_basica_p
and	cd_unidade_compl	= cd_unidade_compl_p;



select	coalesce(max(ie_leito_disp_periodo),'N')
into STRICT	ie_considera_dt_ref_w
from	parametro_atendimento
where	cd_estabelecimento	=	 wheb_usuario_pck.get_cd_estabelecimento;

if (ie_considera_dt_ref_w	=	'S') then

	open C01;
	loop
	fetch C01 into
		ie_temporario_w,
		ie_status_unidade_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		ie_temporario_w		:=	ie_temporario_w;
		ie_status_unidade_w	:=	ie_status_unidade_w;


		end;
	end loop;
	close C01;

end if;

if (coalesce(nr_sequencia_w,0) = 0) then

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_sequencia_w
	from	unidade_atend_hist
	where	nr_seq_unidade		= nr_seq_interno_w
	and	dt_historico		between trunc(dt_referencia_p - 30, 'dd') and trunc(dt_referencia_p, 'dd');

	if (nr_sequencia_w = 0) then

		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_sequencia_w
		from	unidade_atend_hist
		where	nr_seq_unidade		= nr_seq_interno_w
		and	dt_historico		< trunc(dt_referencia_p, 'dd');

	end if;

	if (nr_sequencia_w > 0) then

		select	ie_temporario,
			ie_status_unidade
		into STRICT	ie_temporario_w,
			ie_status_unidade_w
		from	unidade_atend_hist
		where	nr_sequencia		= nr_sequencia_w;


	end if;

end if;


ie_temporario_w		:=	coalesce(ie_temporario_w,ie_temporario_atual_w);
ie_status_unidade_w	:=	coalesce(ie_status_unidade_w,ie_status_unidade_atual_w);


if (ie_status_unidade_w	in ('I', 'A', 'O', 'H', 'R','E')) then
	ie_disponivel_w		:= 'N';
elsif (ie_temporario_w	= 'S') then
	begin

	if (ie_status_unidade_w	= 'L') then
		ie_disponivel_w		:= 'S';
	elsif (ie_status_unidade_w	= 'P') then
		ie_disponivel_w		:= 'N';
	end if;


	end;
else
	begin

	if (ie_status_unidade_w	= 'L') then
		ie_disponivel_w		:= 'S';
	elsif (ie_status_unidade_w	= 'P') then
		ie_disponivel_w		:= 'N';
	end if;


	end;
end if;

return	ie_disponivel_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_leito_disp_periodo (cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, dt_referencia_p timestamp) FROM PUBLIC;

