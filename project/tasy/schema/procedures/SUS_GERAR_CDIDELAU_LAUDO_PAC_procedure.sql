-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_cdidelau_laudo_pac ( nr_seq_lote_p bigint, ie_tipo_laudo_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_interno_conta_w		conta_paciente.nr_interno_conta%type;
nr_seq_interno_w		sus_laudo_paciente.nr_seq_interno%type;
nr_ordem_laudo_w		sus_laudo_paciente.nr_ordem_laudo%type;
cd_prestador_laudo_ach_w	sus_parametros_aih.cd_prestador_laudo_ach%type;
dt_emissao_w			timestamp;
nr_ordem_laudo_ww		varchar(6);
ds_conteudo_w			varchar(255) := '';

C01 CURSOR FOR 
	SELECT	nr_interno_conta, 
		nr_seq_interno 
	from	sus_laudo_paciente 
	where	nr_seq_lote = nr_seq_lote_p;


BEGIN 
 
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then 
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_interno_conta_w, 
		nr_seq_interno_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		select	max(dt_emissao), 
			coalesce(max(nr_ordem_laudo),0) 
		into STRICT	dt_emissao_w, 
			nr_ordem_laudo_w 
		from	sus_laudo_paciente 
		where 	nr_interno_conta = nr_interno_conta_w 
		and	ie_tipo_laudo_sus = ie_tipo_laudo_p;
 
		if (nr_ordem_laudo_w > 0) then 
			begin 
			 
			nr_ordem_laudo_ww := substr(adiciona_zeros_esquerda(substr(to_char(nr_ordem_laudo_w),1,6),6),1,6);
			 
			select	max(cd_prestador_laudo_ach) 
			into STRICT	cd_prestador_laudo_ach_w 
			from	conta_paciente a, 
				sus_parametros_aih b 
			where	a.cd_estabelecimento = b.cd_estabelecimento 
			and	a.nr_interno_conta = nr_interno_conta_w;
			 
			ds_conteudo_w	:= 	substr(to_char(dt_emissao_w,'yyyy') || 
						cd_prestador_laudo_ach_w || 
						nr_ordem_laudo_ww || 
						calcula_Digito('MODULO11',to_char(dt_emissao_w,'yyyy') || 
						cd_prestador_laudo_ach_w || 
						nr_ordem_laudo_ww ),1,13);
 
			insert into sus_id_laudo_ach( 
				nr_sequencia, 
				nr_seq_interno, 
				ds_id_laudo_ach, 
				dt_atualizacao, 
				dt_atualizacao_nrec, 
				nm_usuario, 
				nm_usuario_nrec, 
				nr_seq_lote) 
			values (nextval('sus_id_laudo_ach_seq'), 
				nr_seq_interno_w, 
				ds_conteudo_w, 
				clock_timestamp(), 
				clock_timestamp(), 
				nm_usuario_p, 
				nm_usuario_p, 
				nr_seq_lote_p);
			 
			end;
		end if;		
		 
		end;
	end loop;
	close C01;
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_cdidelau_laudo_pac ( nr_seq_lote_p bigint, ie_tipo_laudo_p bigint, nm_usuario_p text) FROM PUBLIC;
