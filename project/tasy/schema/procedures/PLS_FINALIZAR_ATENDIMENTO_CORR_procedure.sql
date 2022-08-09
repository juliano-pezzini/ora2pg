-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_finalizar_atendimento_corr ( nr_seq_atendimento_p bigint, qt_tempo_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Finalizar o atendimento corrente
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_regra_tempo_w		bigint;
ie_status_atend_w		varchar(1);
nr_seq_tipo_historico_w		bigint;
ds_historico_w			varchar(4000);


BEGIN

select	ie_status
into STRICT	ie_status_atend_w
from	pls_atendimento
where	nr_sequencia = nr_seq_atendimento_p;

if (pls_obter_se_controle_estab('GA') = 'S') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_tipo_historico_w
	from	pls_tipo_historico_atend
	where	ie_gerado_sistema	= 'S'
	and	ie_situacao		= 'A'
	and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento );
else
	select	max(nr_sequencia)
	into STRICT	nr_seq_tipo_historico_w
	from	pls_tipo_historico_atend
	where	ie_gerado_sistema	= 'S'
	and	ie_situacao		= 'A';
end if;

if (ie_status_atend_w = 'A') and (coalesce(nr_seq_tipo_historico_w,0)	<> 0) then
	if (pls_obter_se_controle_estab('GA') = 'S') then
		begin
			select 	nr_sequencia
			into STRICT	nr_seq_regra_tempo_w
			from	pls_atend_regra_tempo
			where	ie_situacao = 'A'
			and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento )
			and	qt_tempo_maximo = (	SELECT 	min(qt_tempo_maximo)
							from 	pls_atend_regra_tempo
							where 	qt_tempo_maximo >= qt_tempo_p
							and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento ));
		exception
			when others then
			nr_seq_regra_tempo_w := '';
		end;

		if (coalesce(nr_seq_regra_tempo_w::text, '') = '') then
			select 	max(nr_sequencia)
			into STRICT	nr_seq_regra_tempo_w
			from	pls_atend_regra_tempo
			where	ie_situacao = 'A'
			and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento )
			and	qt_tempo_maximo = (	SELECT 	max(qt_tempo_maximo)
							from 	pls_atend_regra_tempo
							where (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento ));
		end if;
	else
		begin
		select 	nr_sequencia
		into STRICT	nr_seq_regra_tempo_w
		from	pls_atend_regra_tempo
		where	ie_situacao = 'A'
		and	qt_tempo_maximo = (	SELECT min(qt_tempo_maximo)
						from pls_atend_regra_tempo
						where qt_tempo_maximo >= qt_tempo_p);
		exception
			when others then
			nr_seq_regra_tempo_w := '';
		end;

		if (coalesce(nr_seq_regra_tempo_w::text, '') = '') then
			select 	max(nr_sequencia)
			into STRICT	nr_seq_regra_tempo_w
			from	pls_atend_regra_tempo
			where	ie_situacao = 'A'
			and	qt_tempo_maximo = (SELECT max(qt_tempo_maximo) from pls_atend_regra_tempo);
		end if;
	end if;

	update	pls_atendimento
	set	dt_fim_atendimento	= clock_timestamp(),
		dt_atualizacao		= clock_timestamp(),
		nr_seq_regra_tempo	= nr_seq_regra_tempo_w,
		nm_usuario		= nm_usuario_p,
		ie_status		= 'M'
	where	nr_sequencia		= nr_seq_atendimento_p;

	ds_historico_w	:= ('O atendimento foi finalizado através da opção de menu Finalizar atendimento corrente, pelo usuário '||
				nm_usuario_p ||', na data/hora '|| to_char(clock_timestamp(), 'MM-DD-YYYY HH24:MI:SS') ||'.');

	insert	into	pls_atendimento_historico( nr_sequencia, nr_seq_atendimento, ds_historico_long,
		 dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		 nm_usuario_nrec, nr_seq_tipo_historico, dt_historico,
		 ie_gerado_sistema)
	values (nextval('pls_atendimento_historico_seq'), nr_seq_atendimento_p, ds_historico_w,
		 clock_timestamp(), nm_usuario_p, clock_timestamp(),
		 nm_usuario_p, nr_seq_tipo_historico_w, clock_timestamp(),
		 'S');

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_finalizar_atendimento_corr ( nr_seq_atendimento_p bigint, qt_tempo_p bigint, nm_usuario_p text) FROM PUBLIC;
