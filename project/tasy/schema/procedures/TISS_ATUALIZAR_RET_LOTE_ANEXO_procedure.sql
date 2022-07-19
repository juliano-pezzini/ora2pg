-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_atualizar_ret_lote_anexo (nm_usuario_p text, nr_seq_lote_p bigint) AS $body$
DECLARE

		
nr_guia_prestador_w	varchar(20);
nr_guia_operadora_w	varchar(20);
cd_senha_w		varchar(20);
nr_sequencia_autor_w	bigint;
ie_status_solic_w	varchar(1);
cd_estabelecimento_w	smallint;
nr_seq_estagio_w	bigint;
nr_seq_guia_w		bigint;
cd_item_w		varchar(10);
qt_autorizada_w		smallint;
vl_autorizado_w		double precision;	

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_guia_prestador,
	a.nr_guia_operadora,
	a.cd_senha,
	a.ie_status_solic
from	tiss_anexo_guia_imp a,
	tiss_anexo_lote_imp b
where	b.nr_sequencia	= a.nr_seq_lote_imp
and	b.nr_seq_lote	= nr_seq_lote_p;

c02 CURSOR FOR
SELECT	cd_procedimento,
	qt_autorizada,
	vl_autorizado
from	tiss_anexo_guia_item_imp
where	nr_seq_guia_imp	= nr_seq_guia_w
and (qt_autorizada > 0 or vl_autorizado > 0);
		

BEGIN

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	tiss_anexo_lote
where	nr_sequencia	= nr_seq_lote_p;

open C01;
loop
fetch C01 into	
	nr_seq_guia_w,
	nr_guia_prestador_w,
	nr_guia_operadora_w,
	cd_senha_w,	
	ie_status_solic_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	select	max(nr_sequencia)
	into STRICT	nr_sequencia_autor_w
	from	autorizacao_convenio
	where	nr_sequencia	= nr_guia_prestador_w;
	
	nr_seq_estagio_w := tiss_obter_estagio_autor(ie_status_solic_w);
	
	if (coalesce(nr_seq_estagio_w::text, '') = '') then
		/*Estágio da autorização não localizado!
		Verifique o cadastro dos estágios, se todos estão relacionados ao estágio TISS.*/
		CALL wheb_mensagem_pck.exibir_mensagem_abort(249646);
	end if;
	
	if (nr_sequencia_autor_w > 0) then	
	
		update	autorizacao_convenio
		set	cd_senha	= coalesce(cd_senha,cd_senha_w),
			nr_seq_estagio	= nr_seq_estagio_w,	
			cd_autorizacao	= coalesce(cd_autorizacao,nr_guia_operadora_w),
			nm_usuario	= nm_usuario_p,
			dt_atualizacao  = clock_timestamp()
		where	nr_sequencia	= nr_sequencia_autor_w;
		
		open C02;
		loop
		fetch C02 into	
			cd_item_w,
			qt_autorizada_w,
			vl_autorizado_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin			
			CALL TISS_ATUALIZAR_RET_AUTORIZACAO(	nr_sequencia_autor_w,
							cd_item_w, 
							qt_autorizada_w, 
							vl_autorizado_w, 
							nm_usuario_p,
							null,
							'N');			
			end;
		end loop;
		close C02;
	
	end if;
	
	end;
end loop;
close C01;

update	tiss_anexo_lote
set	ie_status	= '4',
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_atualizar_ret_lote_anexo (nm_usuario_p text, nr_seq_lote_p bigint) FROM PUBLIC;

