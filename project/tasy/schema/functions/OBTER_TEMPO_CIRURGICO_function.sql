-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_cirurgico (nr_sequencia_p bigint, ie_opcao_p text, nr_seq_evento_p bigint DEFAULT 0, nr_cirurgia_p bigint DEFAULT 0) RETURNS varchar AS $body$
DECLARE


ds_tempo_w	 	varchar(150);
nr_seq_evento_w 	bigint;
ds_tempo_retorno_w	varchar(4000);
ie_estrutura_pepo_w	varchar(1);

C01 CURSOR FOR
	SELECT 	substr(ds_tempo,1,150),
		nr_seq_evento
	from	tempo_cirurgico
	where	nr_seq_evento_dif = nr_sequencia_p
	order by 1;


BEGIN

ie_estrutura_pepo_w := obter_param_usuario(872, 158, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_estrutura_pepo_w);

if (ie_opcao_p = 'I') then
	select 	substr(max(ds_tempo),1,150)
	into STRICT	ds_tempo_retorno_w
	from	tempo_cirurgico
	where	nr_seq_evento = nr_sequencia_p;
elsif (ie_opcao_p = 'S') then
	select 	substr(max(ds_tempo),1,150)
	into STRICT	ds_tempo_retorno_w
	from	tempo_cirurgico
	where	nr_sequencia = nr_sequencia_p;
else
	if (ie_estrutura_pepo_w = 'S') then
		open C01;
		loop
		fetch C01 into
			ds_tempo_w,
			nr_seq_evento_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			ds_tempo_retorno_w := ds_tempo_retorno_w||' - '||ds_tempo_w||obter_duracao_evento(nr_seq_evento_w,nr_seq_evento_p ,nr_cirurgia_p);
			end;
		end loop;
		close C01;
	else
		select 	substr(max(ds_tempo),1,150)
		into STRICT	ds_tempo_retorno_w
		from	tempo_cirurgico
		where	nr_seq_evento_dif = nr_sequencia_p;
	end if;

end if;


return ds_tempo_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_cirurgico (nr_sequencia_p bigint, ie_opcao_p text, nr_seq_evento_p bigint DEFAULT 0, nr_cirurgia_p bigint DEFAULT 0) FROM PUBLIC;
