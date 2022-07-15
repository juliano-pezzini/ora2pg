-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_conta_convenio_atual ( cd_convenio_p conta_convenio_atual.cd_convenio%type, dt_competencia_p conta_convenio_atual.dt_competencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


qt_reg_compet_w		bigint := 0;
qt_reg_w		bigint := 0;
nr_sequencia_w		conta_convenio_atual.nr_sequencia%type;
nr_sequencia_ww		conta_convenio_atual.nr_sequencia%type;


BEGIN

select	count(1)
into STRICT	qt_reg_w
from	conta_convenio_atual
where	ie_situacao = 'A'  LIMIT 1;

if (qt_reg_w > 0) then
	begin

	select	count(1)
	into STRICT	qt_reg_compet_w
	from	conta_convenio_atual
	where	cd_convenio = cd_convenio_p
	and	ie_situacao = 'A'
	and	coalesce(dt_competencia::text, '') = ''  LIMIT 1;

	if (qt_reg_compet_w > 0) then
		begin

		update	conta_convenio_atual
		set 	dt_competencia = trunc(dt_competencia_p,'month')
		where 	cd_convenio = cd_convenio_p
		and	ie_situacao = 'A'
		and	coalesce(dt_competencia::text, '') = '';

		commit;

		end;
	else
		begin

		select	count(1)
		into STRICT	qt_reg_compet_w
		from	conta_convenio_atual
		where	cd_convenio = cd_convenio_p
		and	ie_situacao = 'A'
		and	trunc(dt_competencia,'month') = trunc(dt_competencia_p,'month')  LIMIT 1;

		if (qt_reg_compet_w = 0) then
			begin

			begin
			select	nr_sequencia
			into STRICT	nr_sequencia_ww
			from	conta_convenio_atual a
			where	a.cd_convenio = cd_convenio_p
			and	a.ie_situacao = 'A'
			and	trunc(a.dt_competencia,'month') =
				(	SELECT	max(trunc(x.dt_competencia,'month'))
					from 	conta_convenio_atual x
					where	x.cd_convenio = a.cd_convenio
					and	x.ie_situacao = 'A')  LIMIT 1;
			exception
			when others then
				nr_sequencia_ww	:= 0;
			end;

			select	nextval('conta_convenio_atual_seq')
			into STRICT	nr_sequencia_w
			;

			insert into conta_convenio_atual(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_convenio,
				ie_situacao,
				nr_conta_inicial,
				nr_final_conta,
				nr_conta_atual,
				dt_competencia)
			SELECT	nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_convenio,
				ie_situacao,
				nr_conta_inicial,
				nr_final_conta,
				null,
				trunc(dt_competencia_p,'month')
			from	conta_convenio_atual
			where	nr_sequencia = nr_sequencia_ww;

			commit;

			end;
		end if;
		end;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_conta_convenio_atual ( cd_convenio_p conta_convenio_atual.cd_convenio%type, dt_competencia_p conta_convenio_atual.dt_competencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

