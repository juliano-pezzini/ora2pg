-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_completar_guia ( nr_seq_guia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_guia_w		bigint;
cont_w			bigint := 0;
nr_seq_apresentacao_w	bigint := 0;
nr_seq_apres_partic_w	bigint := 0;
ie_tiss_tipo_guia_w	varchar(2);
ds_versao_w		varchar(20);

c01 CURSOR FOR
SELECT	nr_sequencia,
	ie_tiss_tipo_guia,
	coalesce(ds_versao,'2.02.03')
from	w_tiss_guia
where	nr_sequencia		= nr_seq_guia_p
and	nm_usuario		= nm_usuario_p;


BEGIN
	
open c01;
loop
fetch c01 into
	nr_seq_guia_w,
	ie_tiss_tipo_guia_w,
	ds_versao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (ie_tiss_tipo_guia_w	= '5') then

		select	count(*)
		into STRICT	cont_w
		from	w_tiss_opm_exec
		where	nr_seq_guia	= nr_seq_guia_w;

		nr_seq_apresentacao_w	:= cont_w;

		while	((cont_w < 5 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'N')) or (cont_w < 10 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'S'))) loop

			nr_seq_apresentacao_w := nr_seq_apresentacao_w + 1;

			insert	into w_tiss_opm_exec(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_opm_exec_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresentacao_w);

			cont_w		:= cont_w + 1;

		end loop;

		select	count(*)
		into STRICT	cont_w
		from	w_tiss_proc_partic
		where	nr_seq_guia	= nr_seq_guia_w;

		nr_seq_apres_partic_w	:= cont_w;

		while	((cont_w < 19 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'N')) or (cont_w < 26 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'S'))) loop

			nr_seq_apres_partic_w := nr_seq_apres_partic_w + 1;

			insert	into w_tiss_proc_partic(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_proc_partic_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apres_partic_w);

			cont_w			:= cont_w + 1;

		end loop;

		select	count(*)
		into STRICT	cont_w
		from	w_tiss_proc_paciente
		where	nr_seq_guia	= nr_seq_guia_w;

		nr_seq_apresentacao_w	:= cont_w;

		while	((cont_w < 15 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'N')) or (cont_w < 24 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'S'))) loop

			nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;

			insert	into w_tiss_proc_paciente(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_proc_paciente_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresentacao_w);

			cont_w	:= cont_w + 1;

		end loop;

	elsif (ie_tiss_tipo_guia_w	= '7') then

		select	count(*)
		into STRICT	cont_w
		from	w_tiss_outras_despesas
		where	nr_seq_guia	= nr_seq_guia_w;

		nr_seq_apresentacao_w	:= cont_w;
	
			
		
		while	((cont_w < 13 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'N')) or (cont_w < 10 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'S'))) loop

			nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;

			insert	into w_tiss_outras_despesas(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_outras_despesas_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresentacao_w);
			cont_w			:= cont_w + 1;

		end loop;

	elsif (ie_tiss_tipo_guia_w	= '6') then

		select	count(*)
		into STRICT	cont_w
		from	w_tiss_proc_paciente
		where	nr_seq_guia	= nr_seq_guia_w;

		nr_seq_apresentacao_w	:= cont_w;
		/*lhalves OS 369466 em 03/11/2011*/

		select	max(nr_seq_apresentacao)
		into STRICT	nr_seq_apresentacao_w
		from	w_tiss_proc_paciente
		where	nr_seq_guia	= nr_seq_guia_w;

		while	cont_w < 10 loop

			nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;

			insert	into w_tiss_proc_paciente(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_proc_paciente_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresentacao_w);

			cont_w		:= cont_w + 1;

		end loop;
		
		if (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'S') then
		
			select	count(*)
			into STRICT	cont_w
			from	w_tiss_proc_partic
			where	nr_seq_guia	= nr_seq_guia_w;

			nr_seq_apres_partic_w	:= cont_w;

			while	cont_w < 5 loop

				nr_seq_apres_partic_w := nr_seq_apres_partic_w + 1;

				insert	into w_tiss_proc_partic(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					nr_seq_guia,
					nr_seq_apresentacao)
				values (nextval('w_tiss_proc_partic_seq'),
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_guia_w,
					nr_seq_apres_partic_w);

				cont_w			:= cont_w + 1;

			end loop;
		end if;

	elsif (ie_tiss_tipo_guia_w	in ('4', '2')) then

		select 	count(*)
		into STRICT 	cont_w
		from 	w_tiss_proc_solic
		where	nr_seq_guia = nr_seq_guia_w;

		nr_seq_apresentacao_w	:= cont_w;

		while(cont_w < 5) loop
			nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;
			insert	into w_tiss_proc_solic(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_proc_solic_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresentacao_w);
			cont_w		:= cont_w + 1;
		end loop;

		select 	count(*)
		into STRICT 	cont_w
		from 	w_tiss_opm
		where	nr_seq_guia = nr_seq_guia_w;

		nr_seq_apresentacao_w	:= cont_w;

		while(cont_w < 9) loop
			nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;
			insert	into w_tiss_opm(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_opm_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresentacao_w);
			cont_w		:= cont_w + 1;
		end loop;

		select	count(*)
		into STRICT	cont_w
		from	w_tiss_opm_exec
		where	nr_seq_guia	= nr_seq_guia_w;

		nr_seq_apresentacao_w	:= cont_w;

		while(cont_w < 9) loop
			nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;
			insert	into w_tiss_opm_exec(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_opm_exec_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresentacao_w);
			cont_w		:= cont_w + 1;
		end loop;

		select	count(*)
		into STRICT	cont_w
		from	w_tiss_proc_paciente
		where	nr_seq_guia	= nr_seq_guia_w;

		nr_seq_apresentacao_w	:= cont_w;

		while(cont_w < 5) loop
			cont_w			:= cont_w + 1;
			nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;
			insert	into w_tiss_proc_paciente(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_proc_paciente_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresentacao_w);
		end loop;
		
		if (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'S') then
		
			select	count(*)
			into STRICT	cont_w
			from	w_tiss_proc_partic
			where	nr_seq_guia	= nr_seq_guia_w;

			nr_seq_apres_partic_w	:= cont_w;

			while	cont_w < 5 loop

				nr_seq_apres_partic_w := nr_seq_apres_partic_w + 1;

				insert	into w_tiss_proc_partic(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					nr_seq_guia,
					nr_seq_apresentacao)
				values (nextval('w_tiss_proc_partic_seq'),
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_guia_w,
					nr_seq_apres_partic_w);

				cont_w			:= cont_w + 1;

			end loop;
		end if;

	elsif (ie_tiss_tipo_guia_w = '1') then

		select	count(*)
		into STRICT	cont_w
		from	w_tiss_opm
		where	nr_seq_guia	= nr_seq_guia_w;

		while	((cont_w < 5 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'N')) or (cont_w < 12 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'S'))) loop

			insert	into w_tiss_opm(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia)
			values (nextval('w_tiss_opm_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w);

			cont_w		:= cont_w + 1;

		end loop;

		cont_w	:= 1;
		while	((cont_w <= 5 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'N')) or (cont_w <= 12 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'S'))) loop
			insert	into w_tiss_proc_paciente(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia)
			values (nextval('w_tiss_proc_paciente_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w);
			cont_w		:= cont_w + 1;
		end loop;

		select	count(*)
		into STRICT	cont_w
		from	w_tiss_proc_solic
		where	nr_seq_guia	= nr_seq_guia_w;

		while	((cont_w < 5 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'N')) or (cont_w < 12 and (obter_se_projeto_versao(0,12,ds_versao_w,0) = 'S'))) loop
			insert	into w_tiss_proc_solic(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia)
			values (nextval('w_tiss_proc_solic_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w);
			cont_w		:= cont_w + 1;
		end loop;
		
	elsif (ie_tiss_tipo_guia_w = '8') then --Prorrogação de internação
	
		select	count(*)
		into STRICT	cont_w
		from	w_tiss_proc_solic
		where	nr_seq_guia	= nr_seq_guia_w;

		while	cont_w < 9 loop
			insert	into w_tiss_proc_solic(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia)
			values (nextval('w_tiss_proc_solic_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w);
			cont_w		:= cont_w + 1;
		end loop;
		
	elsif (ie_tiss_tipo_guia_w = '9') then
	
		select	count(*)
		into STRICT	cont_w
		from	w_tiss_opm
		where	nr_seq_guia	= nr_seq_guia_w;

		nr_seq_apresentacao_w	:= cont_w;
		/*lhalves OS 369466 em 03/11/2011*/

		select	max(nr_seq_apresentacao)
		into STRICT	nr_seq_apresentacao_w
		from	w_tiss_opm
		where	nr_seq_guia	= nr_seq_guia_w;

		while	cont_w < 6 loop

			nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;

			insert	into w_tiss_opm(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_opm_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresentacao_w);

			cont_w		:= cont_w + 1;

		end loop;
		
	elsif (ie_tiss_tipo_guia_w = '10') then
	
		select	count(*)
		into STRICT	cont_w
		from	w_tiss_opm
		where	nr_seq_guia	= nr_seq_guia_w;

		nr_seq_apresentacao_w	:= cont_w;
		/*lhalves OS 369466 em 03/11/2011*/

		select	max(nr_seq_apresentacao)
		into STRICT	nr_seq_apresentacao_w
		from	w_tiss_opm
		where	nr_seq_guia	= nr_seq_guia_w;

		while	cont_w < 8 loop

			nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;

			insert	into w_tiss_opm(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_opm_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresentacao_w);

			cont_w		:= cont_w + 1;

		end loop;
	elsif (ie_tiss_tipo_guia_w = '12') then
	
		select	count(*)
		into STRICT	cont_w
		from	w_tiss_opm
		where	nr_seq_guia	= nr_seq_guia_w;

		nr_seq_apresentacao_w	:= cont_w;
	
		select	max(nr_seq_apresentacao)
		into STRICT	nr_seq_apresentacao_w
		from	w_tiss_opm
		where	nr_seq_guia	= nr_seq_guia_w;

		while	cont_w < 13 loop

			nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;

			insert	into w_tiss_opm(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_opm_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresentacao_w);

			cont_w		:= cont_w + 1;

		end loop;

	elsif (ie_tiss_tipo_guia_w = '11') then
	
		select	count(*)
		into STRICT	cont_w
		from	w_tiss_proc_paciente
		where	nr_seq_guia	= nr_seq_guia_w;

		nr_seq_apresentacao_w	:= cont_w;
	
		select	max(nr_seq_apresentacao)
		into STRICT	nr_seq_apresentacao_w
		from	w_tiss_proc_paciente
		where	nr_seq_guia	= nr_seq_guia_w;

		while	cont_w < 20 loop

			nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;

			insert	into w_tiss_proc_paciente(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_proc_paciente_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresentacao_w);

			cont_w		:= cont_w + 1;

		end loop;

	end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
	
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_completar_guia ( nr_seq_guia_p bigint, nm_usuario_p text) FROM PUBLIC;
