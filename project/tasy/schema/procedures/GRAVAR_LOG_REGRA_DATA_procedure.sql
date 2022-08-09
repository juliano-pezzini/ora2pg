-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_regra_data ( nr_seq_cronograma_p bigint, nm_usuario_p text, cd_perfil_p bigint, dt_inicio_prev_ant_p timestamp, dt_inicio_prev_atual_p timestamp, dt_fim_prev_ant_p timestamp, dt_fim_prev_atual_p timestamp, nr_seq_cron_etapa_p bigint) AS $body$
DECLARE



nr_seq_estagio_w		bigint;
cd_perfil_w				integer;
ie_status_cronograma_w	varchar(3);
ie_operacao_w			varchar(3);
ie_motivo_w				varchar(1);
ie_grava_log_w			varchar(1);
ie_gravar_w				varchar(1);
qt_regra_w				integer;
nr_seq_projeto_w		bigint;




C01 CURSOR FOR
		SELECT 	coalesce(nr_seq_estagio,0),
				coalesce(cd_perfil,0),
				coalesce(ie_status_cronograma,'X'),
				coalesce(ie_operacao,'X'),
				coalesce(ie_motivo,'X'),
				coalesce(ie_grava_log,'X')
		from	gpi_regra_log_data;



BEGIN

ie_gravar_w		:=	'N';

open C01;
loop
fetch C01 into
	nr_seq_estagio_w,
	cd_perfil_w,
	ie_status_cronograma_w,
	ie_operacao_w,
	ie_motivo_w,
	ie_grava_log_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select  nr_seq_projeto
	into STRICT	nr_seq_projeto_w
	from    gpi_cronograma
	where	nr_sequencia = nr_seq_cronograma_p;


	if (nr_seq_estagio_w <> 0)and (ie_grava_log_w = 'S')then
		select  count(*)
		into STRICT    qt_regra_w
		from    gpi_projeto
		where	nr_sequencia   = nr_seq_projeto_w
		and		nr_seq_estagio = nr_seq_estagio_w;

		if (qt_regra_w > 0) then
		    ie_gravar_w	:=	'S';
		else
			ie_gravar_w	:=	'N';
		end if;

	end if;


	if (cd_perfil_w <> 0 ) and (cd_perfil_w = cd_perfil_p)and (ie_grava_log_w = 'S')then
		ie_gravar_w	:=	'S';
		else
		ie_gravar_w	:=	'N';
	end if;

	if (ie_status_cronograma_w <> 'X')and (ie_grava_log_w = 'S')then

		case ie_status_cronograma_w
			when	'AP'	then
				select  count(*)
				into STRICT    qt_regra_w
				from	gpi_cronograma
				where	nr_sequencia = nr_seq_cronograma_p
				and	    (dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> '');

				if (qt_regra_w > 0)	 then
					ie_gravar_w	:=	'S';
				else
				    ie_gravar_w	:=	'N';
				end if;
			when	'LI'	then
				select  count(*)
				into STRICT    qt_regra_w
				from	gpi_cronograma
				where	nr_sequencia = nr_seq_cronograma_p
				and	    (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

				if (qt_regra_w > 0)	 then
					ie_gravar_w	:=	'S';
				else
				    ie_gravar_w	:=	'N';
				end if;

			when	'NL'	then

				select  count(*)
				into STRICT    qt_regra_w
				from	gpi_cronograma
				where	nr_sequencia = nr_seq_cronograma_p
				and	    coalesce(dt_liberacao::text, '') = '';

				if (qt_regra_w > 0)	 then
					ie_gravar_w	:=	'S';
				else
				    ie_gravar_w	:=	'N';
				end if;

		end case;

	end if;

	if (ie_gravar_w = 'S')	then

	insert into gpi_log_data( 	nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								nr_seq_proj_gpi,
								nr_seq_cronograma,
								ds_motivo,
								ds_observacao,
								dt_inicio_prev_ant,
								dt_fim_prev_ant,
								dt_inicio_prev_atu,
								dt_fim_prev_atu,
								nr_seq_cron_etapa,
								ie_operacao,
								ie_impacto)
					values (nextval('gpi_log_data_seq'),
								 clock_timestamp(),
								 nm_usuario_p,
								 nr_seq_projeto_w,
								 nr_seq_cronograma_p,
								 '',
								 '',
								 dt_inicio_prev_ant_p,
								 dt_fim_prev_ant_p,
								 dt_inicio_prev_atual_p,
								 dt_fim_prev_atual_p,
								 nr_seq_cron_etapa_p,
								 '',
								 '');

	end if;


	end;
end loop;
close C01;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_regra_data ( nr_seq_cronograma_p bigint, nm_usuario_p text, cd_perfil_p bigint, dt_inicio_prev_ant_p timestamp, dt_inicio_prev_atual_p timestamp, dt_fim_prev_ant_p timestamp, dt_fim_prev_atual_p timestamp, nr_seq_cron_etapa_p bigint) FROM PUBLIC;
