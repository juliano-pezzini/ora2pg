-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE integra_conta_contab_protheus ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_cadastro_w			varchar(20);
ds_cadastro_w			varchar(80);
qt_registros_w			bigint;
ie_operacao_w			varchar(15);
ie_erro_w			varchar(1) := 'N';
cd_empresa_protheus_w		varchar(10);
cd_empresa_int_w		varchar(10);
qt_contas_w			bigint;


BEGIN

select	cd_cadastro,
	ds_cadastro,
	ie_operacao,
	cd_empresa
into STRICT	cd_cadastro_w,
	ds_cadastro_w,
	ie_operacao_w,
	cd_empresa_protheus_w
from	w_protheus_cadastro
where	nr_sequencia = nr_sequencia_p
and	tp_cadastro = 'CT';

if (coalesce(cd_cadastro_w::text, '') = '') then
	CALL gravar_log_protheus('ERRO', 'CT', WHEB_MENSAGEM_PCK.get_texto(309900), nm_usuario_p); --O código da conta contábil recebida do Protheus está vazia.
	ie_erro_w := 'S';
end if;

if (coalesce(ds_cadastro_w::text, '') = '') then
	CALL gravar_log_protheus('ERRO', 'CT', WHEB_MENSAGEM_PCK.get_texto(309901), nm_usuario_p); --A descrição da conta contábil recebida do Protheus está vazia.
	ie_erro_w := 'S';
end if;

select	obter_conversao_interna_int(null,'EMPRESA','CD_EMPRESA',cd_empresa_protheus_w,'PTH')
into STRICT	cd_empresa_int_w
;

select	count(*)
into STRICT	qt_registros_w
from	empresa
where	cd_empresa = cd_empresa_int_w;

if (qt_registros_w = 0) then
	CALL gravar_log_protheus('ERRO', 'CT', WHEB_MENSAGEM_PCK.get_texto(309902, 'CD_EMPRESA_PROTHEUS_W=' || cd_empresa_protheus_w) , nm_usuario_p); --A conversão para a empresa ' || cd_empresa_protheus_w || ' enviado pelo Protheus está incorreta ou não existe.
	ie_erro_w := 'S';
end if;

if (ie_erro_w = 'N') and (cd_cadastro_w IS NOT NULL AND cd_cadastro_w::text <> '') and (ds_cadastro_w IS NOT NULL AND ds_cadastro_w::text <> '') then
	begin


	if (ie_operacao_w in ('I','A')) then

		select	count(*)
		into STRICT	qt_registros_w
		from	conta_contabil
		where	cd_sistema_contabil = cd_cadastro_w;

		if (qt_registros_w = 0) and (ie_operacao_w = 'I') then


			select	count(*)
			into STRICT	qt_contas_w
			from	conta_contabil
			where	cd_conta_contabil = cd_cadastro_w;

			if (qt_contas_w = 0) then

				insert into conta_contabil(
					cd_conta_contabil,
					ds_conta_contabil,
					cd_empresa,
					ie_centro_custo,
					ie_situacao,
					cd_classificacao,
					ie_tipo,
					ie_compensacao,
					cd_sistema_contabil,
					ie_ecd_reg_bp,
					ie_ecd_reg_dre,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ie_diops,
					ie_deducao_acomp_orc)
				values (
					cd_cadastro_w,
					substr(cd_cadastro_w || ' - ' || ds_cadastro_w,1,255),
					cd_empresa_int_w,
					'S',
					'A',
					'1',
					'A',
					'N',
					cd_cadastro_w,
					'N',
					'N',
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					'N',
					'N');
			else
				update	conta_contabil
				set	cd_sistema_contabil	= cd_cadastro_w,
					ie_situacao		= 'A',
					dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p
				where	cd_conta_contabil 	= cd_cadastro_w;
			end if;

		end if;

		if (qt_registros_w > 0) and (ie_operacao_w = 'A') then

			update	conta_contabil
			set	cd_conta_contabil	= cd_cadastro_w,
				ds_conta_contabil	= substr(cd_cadastro_w || ' - ' || ds_cadastro_w,1,255),
				ie_situacao	= 'A',
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	cd_sistema_contabil	= cd_cadastro_w;

		end if;

	elsif (ie_operacao_w = 'E') then

		update	conta_contabil
		set	ie_situacao = 'I',
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	cd_sistema_contabil = cd_cadastro_w;

	end if;

	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integra_conta_contab_protheus ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
