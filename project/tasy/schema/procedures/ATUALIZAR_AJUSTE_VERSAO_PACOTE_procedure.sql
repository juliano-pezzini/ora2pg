-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_ajuste_versao_pacote (cd_versao_p text, nm_usuario_p text, IE_HOTFIX_P text default 'N') AS $body$
DECLARE

			
qt_ajuste_versao_w	bigint;
nr_pacote_w			bigint;
dt_atualizacao_w	timestamp;
ds_motivo_w			varchar(4000);
ds_motivo_longo_w	text;
ie_compila_w		varchar(10);
qt_compila_w		bigint;
ie_tipo_script_w	varchar(10);
ds_release_incluso_w	varchar(255);
nr_release_max_w	varchar(10);
nr_release_min_w	varchar(10);
nm_usuario_w		varchar(15);
ie_hotfix_w			varchar(1);

C01 CURSOR FOR
	SELECT	distinct coalesce(a.nr_pacote,0),
			trunc(a.dt_atualizacao),
			nm_usuario,
			ie_hotfix
	from	ajuste_versao_cliente a
	where	a.cd_versao = cd_versao_p;	
	
C02 CURSOR FOR
	SELECT	distinct a.ds_motivo,
			a.ie_tipo_script
	from	ajuste_versao_cliente a
	where	a.cd_versao = cd_versao_p
	and		coalesce(a.nr_pacote,0) = coalesce(nr_pacote_w,0);
	


BEGIN

delete from ajuste_versao_cliente_pac
where cd_versao = cd_versao_p;
commit;

select	count(*)
into STRICT	qt_ajuste_versao_w
from	ajuste_versao_cliente a
where	a.cd_versao = cd_versao_p;

if (qt_ajuste_versao_w > 0) then

	open C01;
	loop
	fetch C01 into	
		nr_pacote_w,
		dt_atualizacao_w,
		nm_usuario_w,
		ie_hotfix_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
			ds_motivo_longo_w:= '';
			open C02;
			loop
			fetch C02 into	
				ds_motivo_w,
				ie_tipo_script_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				   begin
					ds_motivo_longo_w:=ds_motivo_longo_w||CHR(13)||CHR(10)||CHR(13)||CHR(10)||ds_motivo_w;
				   exception
				   when others then
				   	ie_tipo_script_w:=ie_tipo_script_w;
				   end;
				end;
			end loop;
			close C02;

			select	coalesce(MIN(ie_compila),'N')
			into STRICT	ie_compila_w
			from	ajuste_versao_cliente
			where	cd_versao = cd_versao_p
			and		nr_pacote = nr_pacote_w;			
			
			select	min(nr_release)
			into STRICT	nr_release_min_w
			from	ajuste_versao_cliente
			where	cd_versao = cd_versao_p
			and		coalesce(nr_pacote,0) = coalesce(nr_pacote_w,0);
			
			select	max(nr_release)
			into STRICT	nr_release_max_w
			from	ajuste_versao_cliente
			where	cd_versao = cd_versao_p
			and		coalesce(nr_pacote,0) = coalesce(nr_pacote_w,0);
			
			if (ie_tipo_script_w <> 'N') then
				ds_release_incluso_w:= '('||nr_release_min_w||')';
			else
				ds_release_incluso_w:= '('||nr_release_min_w || ' - ' || nr_release_max_w || ')';
			end if;
			
			
			insert into AJUSTE_VERSAO_CLIENTE_PAC(NR_SEQUENCIA,
													DT_ATUALIZACAO,
													NM_USUARIO,
													DT_ATUALIZACAO_NREC,
													NM_USUARIO_NREC,
													NR_PACOTE,
													IE_COMPILA,
													DS_MOTIVO,
													CD_VERSAO,
													IE_TIPO_SCRIPT,
													DS_RELEASE_INCLUSO,
													ie_hotfix)
											values (	nextval('ajuste_versao_cliente_pac_seq'),
													dt_atualizacao_w,
													nm_usuario_w,
													clock_timestamp(),
													nm_usuario_w,
													nr_pacote_w,
													ie_compila_w,
													ds_motivo_longo_w,
													cd_versao_p,
													ie_tipo_script_w,
													ds_release_incluso_w,
													ie_hotfix_w);
													
			commit;
			
		
		end;
	end loop;
	close C01;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_ajuste_versao_pacote (cd_versao_p text, nm_usuario_p text, IE_HOTFIX_P text default 'N') FROM PUBLIC;

