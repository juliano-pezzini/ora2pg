-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_usuario_plano_ag (cd_pessoa_fisica_p text, dt_atendimento_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, cd_usuario_plano_p INOUT text, dt_validade_p INOUT timestamp) AS $body$
DECLARE


nr_seq_segurado_w		bigint;
nr_seq_carteira_w		bigint;
ds_carteira_w			varchar(2000)	:= '';
dt_validade_carteira_w		timestamp		:= null;
ie_atualiza_dt_vencida_w	varchar(1);

c01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_contrato b,
			pls_segurado a
	where	a.nr_seq_contrato	= b.nr_sequencia
	and		cd_pessoa_fisica	= cd_pessoa_fisica_p
	and		coalesce(a.dt_limite_utilizacao,dt_atendimento_p)  >= dt_atendimento_p
	and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');


BEGIN

ie_atualiza_dt_vencida_w := obter_param_usuario(821, 379, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualiza_dt_vencida_w);

open c01;
loop
fetch c01 into	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_carteira_w
	from	pls_segurado_carteira
	where	nr_seq_segurado	= nr_seq_segurado_w;

	select	Max(dt_validade_carteira)
	into STRICT	dt_validade_carteira_w
	from	pls_segurado_carteira
	where	nr_sequencia	= nr_seq_carteira_w;

	if (dt_validade_carteira_w IS NOT NULL AND dt_validade_carteira_w::text <> '') and (dt_validade_carteira_w < clock_timestamp()) and (ie_atualiza_dt_vencida_w = 'N') then
		nr_seq_carteira_w 		:= null;
		dt_validade_carteira_w 	:= null;
	end if;

	if (nr_seq_carteira_w <> 0) then
		if (coalesce(ds_carteira_w::text, '') = '') then
			ds_carteira_w	:= to_char(nr_seq_carteira_w);
		else
			ds_carteira_w	:= ds_carteira_w || ',' || to_char(nr_seq_carteira_w);
		end if;
	end if;

end loop;
close c01;

/*if	(nvl(ds_carteira_w,'X') <> 'X') then
	ds_carteira_w	:= substr(ds_carteira_w, 1, length(ds_carteira_w) - 1);
end if;*/
if (position(',' in ds_carteira_w) = 0) and (nr_seq_carteira_w IS NOT NULL AND nr_seq_carteira_w::text <> '') then

	select	substr(Max(cd_usuario_plano),1,255),
			Max(dt_validade_carteira)
	into STRICT	ds_carteira_w,
			dt_validade_carteira_w
	from	pls_segurado_carteira
	where	nr_sequencia	= nr_seq_carteira_w;
end if;

cd_usuario_plano_p	:= substr(ds_carteira_w,1,255);
dt_validade_p		:= dt_validade_carteira_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_usuario_plano_ag (cd_pessoa_fisica_p text, dt_atendimento_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint, cd_usuario_plano_p INOUT text, dt_validade_p INOUT timestamp) FROM PUBLIC;
