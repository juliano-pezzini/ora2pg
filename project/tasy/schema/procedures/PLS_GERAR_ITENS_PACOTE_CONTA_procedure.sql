-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_itens_pacote_conta ( nr_seq_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_procedimento_w		bigint;
nr_seq_pacote_w			bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_proc_mat_w		bigint;
ie_proc_mat_w			varchar(1);
ie_via_acesso_w			varchar(1);
ie_tecnica_utilizada_w		varchar(1);
dt_procedimento_w		timestamp;
dt_inicio_proc_w		timestamp;
dt_fim_proc_w			timestamp;
tx_item_w			double precision;
nr_seq_setor_atend_w		bigint;
qt_procedimento_w		bigint;
qt_proc_mat_pac_w		bigint;
ie_origem_proced_w		bigint;
ie_tipo_guia_w			varchar(2);
qt_proc_mat_w			bigint;
nr_seq_material_w		bigint;

/*Buscar pacotes e quantidade de pacote*/
 
C01 CURSOR FOR 
	SELECT	cd_procedimento, 
		coalesce(sum(qt_procedimento_imp),0), 
		ie_origem_proced 
	from	pls_conta_proc 
	where	nr_seq_conta	= nr_seq_conta_p 
	and	ie_tipo_despesa	= 4 
	group by cd_procedimento, 
		 ie_origem_proced;
/* Pegar regras do pacote */
C02 CURSOR FOR 
	SELECT	nr_sequencia 
	from	pls_pacote 
	where	cd_procedimento		= cd_procedimento_w 
	and	ie_origem_proced	= ie_origem_proced_w 
	and	ie_situacao		= 'A';
/* Pegar itens do pacote */
C03 CURSOR FOR 
	SELECT	nr_sequencia, 
		ie_origem_proced, 
		'P' 
	from	pls_pacote_procedimento 
	where	nr_seq_pacote	= nr_seq_pacote_w 
	and	ie_situacao	= 'A' 
	and	((ie_tipo_guia	= ie_tipo_guia_w) or (coalesce(ie_tipo_guia::text, '') = '')) 
	
union all
 
	SELECT	nr_sequencia, 
		null, 
		'M' 
	from	pls_pacote_material 
	where	nr_seq_pacote	= nr_seq_pacote_w 
	and	ie_situacao	= 'A' 
	and	((ie_tipo_guia	= ie_tipo_guia_w) or (coalesce(ie_tipo_guia::text, '') = ''));


BEGIN 
 
select	ie_tipo_guia 
into STRICT	ie_tipo_guia_w 
from	pls_conta 
where	nr_sequencia	= nr_seq_conta_p;
 
open C01;
loop 
fetch C01 into	 
	cd_procedimento_w, 
	qt_procedimento_w, 
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	/*Pegar augumas informações para os itens do pacote */
 
	begin 
	select	nr_sequencia, 
		ie_via_acesso, 
		ie_tecnica_utilizada, 
		dt_procedimento, 
		dt_inicio_proc, 
		dt_fim_proc, 
		tx_item, 
		nr_seq_setor_atend 
	into STRICT	nr_seq_conta_proc_w, 
		ie_via_acesso_w, 
		ie_tecnica_utilizada_w, 
		dt_procedimento_w, 
		dt_inicio_proc_w, 
		dt_fim_proc_w, 
		tx_item_w, 
		nr_seq_setor_atend_w 
	from	pls_conta_proc 
	where	cd_procedimento		= cd_procedimento_w 
	and	nr_seq_conta		= nr_seq_conta_p 
	and	ie_origem_proced	= ie_origem_proced_w 
	and	ie_tipo_despesa	= 4 
	and	coalesce(nr_seq_pacote::text, '') = '' 
	group by ie_via_acesso, 
		ie_tecnica_utilizada, 
		dt_procedimento, 
		dt_inicio_proc, 
		dt_fim_proc, 
		tx_item, 
		nr_seq_setor_atend;
	exception 
	when others then 
		nr_seq_conta_proc_w	:= '';
		ie_via_acesso_w		:= '';
		ie_tecnica_utilizada_w	:= '';
		dt_procedimento_w	:= '';
		dt_inicio_proc_w	:= '';
		dt_fim_proc_w		:= '';
		tx_item_w		:= '';
		nr_seq_setor_atend_w	:= '';
	end;
	 
	open C02;
	loop 
	fetch C02 into	 
		nr_seq_pacote_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		open C03;
		loop 
		fetch C03 into	 
			nr_seq_proc_mat_w, 
			ie_origem_proced_w, 
			ie_proc_mat_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin 
			if (ie_proc_mat_w	= 'P') then				 
				/* Pegar a quantidade de itens */
 
				select	coalesce(sum(qt_procedimento),1), 
					cd_procedimento 
				into STRICT	qt_proc_mat_pac_w, 
					cd_procedimento_w 
				from	pls_pacote_procedimento 
				where	nr_sequencia	= nr_seq_proc_mat_w 
				group by cd_procedimento;
				 
				/*Não duplicar o procedimento ao consistir 2 vezes*/
 
				select	count(*) 
				into STRICT	qt_proc_mat_w 
				from	pls_conta_proc 
				where	cd_procedimento		= cd_procedimento_w 
				and	ie_origem_proced	= ie_origem_proced_w 
				and	nr_seq_conta		= nr_seq_conta_p 
				and	(nr_seq_pacote IS NOT NULL AND nr_seq_pacote::text <> '');
 
				if (qt_proc_mat_w = 0) then 
				 
					/* Caso tiver mais de um item deve mutiplicar a quantidade de itens para a quantidade de procedimento da conta 
					   Exmpl :. Na conta posso possuir um pacote com quantidade 10 segnifica que tenho 10 pacotes, ou 
					   posso possuir 2 pacotes separados com a mesmo código para isso não presiso criar o pacote repidas vezes, posso criar o pacote com a quantidade de vezes */
 
					if (qt_procedimento_w > 1) then 
						qt_proc_mat_pac_w := (qt_proc_mat_pac_w * qt_procedimento_w);
					end if;	
					insert into pls_conta_proc(nr_sequencia, ie_via_acesso, ie_tecnica_utilizada, 
							dt_procedimento, dt_inicio_proc, dt_fim_proc, 
							tx_item, nr_seq_setor_atend, qt_procedimento_imp, 
							vl_unitario_imp, vl_procedimento_imp, ie_status, 
							nr_seq_proc_princ, nr_seq_pacote, cd_procedimento, 
							nm_usuario, dt_atualizacao, nm_usuario_nrec, 
							dt_atualizacao_nrec, ie_situacao, nr_seq_conta, 
							ie_origem_proced) 
					(SELECT		nextval('pls_conta_proc_seq'), ie_via_acesso_w, ie_tecnica_utilizada_w, 
							dt_procedimento_w, dt_inicio_proc_w, dt_fim_proc_w, 
							tx_item_w, nr_seq_setor_atend_w, qt_proc_mat_pac_w, 
							0, 0, 'U', 
							nr_seq_conta_proc_w, nr_seq_pacote_w, cd_procedimento, 
							nm_usuario_p, clock_timestamp(), nm_usuario_p, 
							clock_timestamp(), 'I', nr_seq_conta_p, 
							ie_origem_proced_w 
					from		pls_pacote_procedimento 
					where		nr_sequencia	= nr_seq_proc_mat_w);
				end if;
			end if;
 
			if (ie_proc_mat_w	= 'M') then 
				/* Pegar a quantidade de itens */
 
				select	coalesce(sum(qt_material),1), 
					nr_seq_material 
				into STRICT	qt_proc_mat_pac_w, 
					nr_seq_material_w 
				from	pls_pacote_material 
				where	nr_sequencia	= nr_seq_proc_mat_w 
				group by nr_seq_material;
				/*Não duplicar o material ao consistir 2 vezes*/
 
				select	count(*) 
				into STRICT	qt_proc_mat_w 
				from	pls_conta_mat 
				where	nr_seq_material = nr_seq_material_w 
				and	nr_seq_conta		= nr_seq_conta_p 
				and	(nr_seq_pacote IS NOT NULL AND nr_seq_pacote::text <> '');
				 
				if (qt_proc_mat_w = 0) then 
					 
					/* Caso tiver mais de um item deve mutiplicar a quantidade de itens para a quantidade de procedimento da conta 
					   Exmpl :. Na conta posso possuir um pacote com quantidade 10 segnifica que tenho 10 pacotes, ou 
					   posso possuir 2 pacotes separados com a mesmo código para isso não presiso criar o pacote repidas vezes, posso criar o pacote com a quantidade de vezes */
 
					if (qt_procedimento_w > 1) then 
						qt_proc_mat_pac_w := (qt_proc_mat_pac_w * qt_procedimento_w);
					end if;
					insert into pls_conta_mat(nr_sequencia, nr_seq_material, dt_atendimento, 
							dt_inicio_atend, dt_fim_atend, tx_reducao_acrescimo, 
							nr_seq_setor_atend, qt_material_imp, 
							vl_unitario_imp, vl_material_imp, ie_status, 
							nr_seq_mat_princ, nr_seq_pacote, nm_usuario, 
							dt_atualizacao, nm_usuario_nrec, dt_atualizacao_nrec, 
							ie_situacao, nr_seq_conta) 
					(SELECT		nextval('pls_conta_mat_seq'), nr_seq_material, dt_procedimento_w, 
							dt_inicio_proc_w, dt_fim_proc_w, tx_item_w, 
							nr_seq_setor_atend_w, qt_proc_mat_pac_w, 
							0, 0 , 'U', 
							null, nr_seq_pacote_w, nm_usuario_p, 
							clock_timestamp(), nm_usuario_p, clock_timestamp(), 
							 'I', nr_seq_conta_p 
					from		pls_pacote_material 
					where		nr_sequencia	= nr_seq_proc_mat_w);
				end if;
			end if;
			end;
		end loop;
		close C03;
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;
/* 
commit; Não deve haver commit em prcedure intermedária 
*/
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_itens_pacote_conta ( nr_seq_conta_p bigint, nm_usuario_p text) FROM PUBLIC;
